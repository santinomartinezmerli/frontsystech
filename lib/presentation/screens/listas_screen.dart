import 'package:flutter/material.dart';
import 'package:pf_systech_frontend/data/repositories/listas_repository.dart';
import 'package:pf_systech_frontend/domain/models/lista_source.dart';

/// Catálogo de listas de antecedentes.
/// Las listas las provee y carga Systech mediante el ingestor; los clientes
/// (bancos) no las gestionan. Alta y baja son acciones del administrador.
// TODO: mostrar "Agregar" y "Eliminar" solo si el usuario logueado es administrador.
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // TODO: reemplazar por la implementación real cuando exista el endpoint.
  final ListasRepository _repo = ListasMockRepository();

  List<ListaSource>? _listas;
  bool _error = false;

  static const _panel = Color(0xFF0F3277);
  static const _border = Color(0xFF1E428F);
  static const _acento = Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final listas = await _repo.obtenerListas();
      if (!mounted) return;
      setState(() {
        _listas = listas;
        _error = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = true);
    }
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _agregar() async {
    final datos = await showDialog<_NuevaFuente>(
      context: context,
      builder: (_) => const _AgregarFuenteDialog(),
    );
    if (!mounted || datos == null) return;
    try {
      await _repo.agregarLista(
        nombre: datos.nombre,
        jurisdiccion: datos.jurisdiccion,
        urlDescarga: datos.url,
      );
      await _cargar();
      if (!mounted) return;
      _mensaje('Fuente "${datos.nombre}" agregada. Queda pendiente de carga por el ingestor.');
    } catch (_) {
      if (!mounted) return;
      _mensaje('No se pudo agregar la fuente.');
    }
  }

  Future<void> _eliminar(ListaSource lista) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _panel,
        title: const Text('Eliminar fuente', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Eliminar "${lista.nombre}" del catálogo? Los clientes dejarán de poder '
          'consultarla.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    try {
      await _repo.eliminarLista(lista.id);
      await _cargar();
      if (!mounted) return;
      _mensaje('Fuente "${lista.nombre}" eliminada.');
    } catch (_) {
      if (!mounted) return;
      _mensaje('No se pudo eliminar la fuente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 8, 36, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Listas',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      'Listas de antecedentes provistas y mantenidas por Systech.',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _acento,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                onPressed: _agregar,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar fuente'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _aviso(),
          const SizedBox(height: 16),
          Expanded(child: _contenido()),
        ],
      ),
    );
  }

  Widget _contenido() {
    if (_error) {
      return const Center(
        child: Text('No se pudieron cargar las listas.', style: TextStyle(color: Colors.white70)),
      );
    }
    if (_listas == null) return const Center(child: CircularProgressIndicator());
    return _tabla(_listas!);
  }

  Widget _aviso() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Las cifras no deben sumarse entre listas (hay duplicados entre jurisdicciones) '
              'y provienen de OpenSanctions, no de certificaciones oficiales. '
              '«Objetivos» son los sujetos sancionados; «Total» incluye domicilios y otros objetos.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabla(List<ListaSource> listas) {
    return Container(
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _fila(
            const ['Fuente', 'Jurisdicción', 'Objetivos', 'Total procesado', 'Última actualización'],
            header: true,
          ),
          const Divider(height: 1, color: _border),
          Expanded(
            child: ListView.separated(
              itemCount: listas.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: _border),
              itemBuilder: (context, i) {
                final l = listas[i];
                final pendiente = l.estado == ListaEstado.actualizando;
                return _fila([
                  l.nombre,
                  l.jurisdiccion,
                  _num(l.objetivos, pendiente),
                  _num(l.totalProcesado, pendiente),
                  _fecha(l.ultimaActualizacion),
                ], lista: l);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _fila(List<String> celdas, {bool header = false, ListaSource? lista}) {
    final style = TextStyle(
      color: header ? Colors.white54 : Colors.white,
      fontSize: header ? 12 : 14,
      fontWeight: header ? FontWeight.w600 : FontWeight.normal,
    );
    const flex = [3, 3, 2, 2, 3, 2];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: header ? 14 : 8),
      child: Row(
        children: [
          for (var i = 0; i < celdas.length; i++)
            Expanded(flex: flex[i], child: Text(celdas[i], style: style)),
          Expanded(
            flex: flex[5],
            child: header
                ? Text('Estado', style: style)
                : Row(
                    children: [
                      _chipEstado(lista!.estado),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Eliminar fuente',
                        icon: const Icon(Icons.delete_outline, color: Colors.white54, size: 20),
                        onPressed: () => _eliminar(lista),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chipEstado(ListaEstado e) {
    final (texto, color) = switch (e) {
      ListaEstado.activa => ('Activa', const Color(0xFF22C55E)),
      ListaEstado.actualizando => ('Pendiente', const Color(0xFFF59E0B)),
      ListaEstado.error => ('Error', const Color(0xFFEF4444)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(texto, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  // Formato es-AR (punto como separador de miles) sin depender de intl.
  String _num(int? n, bool pendiente) {
    if (n == null) return pendiente ? 'Pendiente de carga' : 'Sin cifra validada';
    return n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  }

  String _fecha(DateTime? d) {
    if (d == null) return '—';
    String dos(int v) => v.toString().padLeft(2, '0');
    return '${dos(d.day)}/${dos(d.month)}/${d.year}';
  }
}

class _NuevaFuente {
  final String nombre;
  final String jurisdiccion;
  final String url;
  const _NuevaFuente(this.nombre, this.jurisdiccion, this.url);
}

class _AgregarFuenteDialog extends StatefulWidget {
  const _AgregarFuenteDialog();

  @override
  State<_AgregarFuenteDialog> createState() => _AgregarFuenteDialogState();
}

class _AgregarFuenteDialogState extends State<_AgregarFuenteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _jurisdiccion = TextEditingController();
  final _url = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _jurisdiccion.dispose();
    _url.dispose();
    super.dispose();
  }

  String? _requerido(String? v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  String? _validarUrl(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
    final uri = Uri.tryParse(v.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return 'Ingresá una URL https válida';
    }
    return null;
  }

  InputDecoration _deco(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF16253B),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A60)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
      );

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _NuevaFuente(_nombre.text.trim(), _jurisdiccion.text.trim(), _url.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F3277),
      title: const Text('Agregar fuente', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                style: const TextStyle(color: Colors.white),
                decoration: _deco('Nombre (ej. OFAC SDN)'),
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _jurisdiccion,
                style: const TextStyle(color: Colors.white),
                decoration: _deco('Jurisdicción'),
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _url,
                style: const TextStyle(color: Colors.white),
                decoration: _deco('URL de descarga (https)'),
                validator: _validarUrl,
              ),
              const SizedBox(height: 10),
              const Text(
                'El ingestor descargará y cargará la lista desde esta URL. '
                'Usá solo URLs oficiales o de un proveedor licenciado.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
          onPressed: _guardar,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
