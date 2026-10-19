import 'package:flutter/material.dart';
import 'package:pf_systech_frontend/data/repositories/listas_repository.dart';
import 'package:pf_systech_frontend/domain/models/lista_source.dart';

/// Catálogo de listas de antecedentes (solo lectura).
/// Las listas las provee y carga Systech mediante el ingestor.
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // TODO: reemplazar por la implementación real cuando exista el endpoint.
  final ListasRepository _repo = ListasMockRepository();
  late final Future<List<ListaSource>> _future = _repo.obtenerListas();

  static const _panel = Color(0xFF0F3277);
  static const _border = Color(0xFF1E428F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 8, 36, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Listas',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'Listas de antecedentes provistas y mantenidas por Systech.',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _aviso(),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<ListaSource>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError || !snap.hasData) {
                  return const Center(
                    child: Text('No se pudieron cargar las listas.',
                        style: TextStyle(color: Colors.white70)),
                  );
                }
                return _tabla(snap.data!);
              },
            ),
          ),
        ],
      ),
    );
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
                return _fila([
                  l.nombre,
                  l.jurisdiccion,
                  _num(l.objetivos),
                  _num(l.totalProcesado),
                  _fecha(l.ultimaActualizacion),
                ], estado: l.estado);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _fila(List<String> celdas, {bool header = false, ListaEstado? estado}) {
    final style = TextStyle(
      color: header ? Colors.white54 : Colors.white,
      fontSize: header ? 12 : 14,
      fontWeight: header ? FontWeight.w600 : FontWeight.normal,
    );
    const flex = [3, 3, 2, 2, 3, 2];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          for (var i = 0; i < celdas.length; i++) ...[
            Expanded(flex: flex[i], child: Text(celdas[i], style: style)),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: flex[5],
            child: header
                ? Text('Estado', style: style)
                : _chipEstado(estado ?? ListaEstado.activa),
          ),
        ],
      ),
    );
  }

  Widget _chipEstado(ListaEstado e) {
    final (texto, color) = switch (e) {
      ListaEstado.activa => ('Activa', const Color(0xFF22C55E)),
      ListaEstado.actualizando => ('Actualizando', const Color(0xFFF59E0B)),
      ListaEstado.error => ('Error', const Color(0xFFEF4444)),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(texto, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // Formato es-AR (punto como separador de miles) sin depender de intl.
  String _num(int? n) {
    if (n == null) return 'Sin cifra validada';
    return n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  }

  String _fecha(DateTime? d) {
    if (d == null) return '—';
    String dos(int v) => v.toString().padLeft(2, '0');
    return '${dos(d.day)}/${dos(d.month)}/${d.year}';
  }
}
