import 'package:pf_systech_frontend/domain/models/lista_source.dart';

/// Contrato para administrar el catálogo de listas.
/// Hoy lo implementa un mock; después se reemplaza por llamadas al backend.
/// Alta y baja son operaciones de administrador de Systech.
abstract class ListasRepository {
  Future<List<ListaSource>> obtenerListas();

  /// Da de alta una fuente; el ingestor la descargará desde [urlDescarga].
  Future<ListaSource> agregarLista({
    required String nombre,
    required String jurisdiccion,
    required String urlDescarga,
  });

  Future<void> eliminarLista(String id);
}

/// DATOS MOCK en memoria. Cifras tomadas del catálogo técnico de Systech
/// (corte 16/10/2026; Australia 07/10). Son de OpenSanctions, no oficiales.
class ListasMockRepository implements ListasRepository {
  late final List<ListaSource> _listas = _inicial();

  static List<ListaSource> _inicial() {
    final corte = DateTime(2026, 10, 16);
    return [
      ListaSource(id: 'ofac-sdn', nombre: 'OFAC SDN', jurisdiccion: 'Estados Unidos',
          objetivos: 20420, totalProcesado: 72562, ultimaActualizacion: corte),
      ListaSource(id: 'ofac-non-sdn', nombre: 'OFAC Non-SDN', jurisdiccion: 'Estados Unidos',
          objetivos: 711, totalProcesado: 2046, ultimaActualizacion: corte),
      ListaSource(id: 'onu-unsc', nombre: 'ONU - UNSC', jurisdiccion: 'Naciones Unidas',
          objetivos: 1004, totalProcesado: 2922, ultimaActualizacion: corte),
      ListaSource(id: 'ue-fsf', nombre: 'UE - FSF', jurisdiccion: 'Unión Europea',
          objetivos: 6128, totalProcesado: 15948, ultimaActualizacion: corte),
      ListaSource(id: 'uk', nombre: 'Reino Unido', jurisdiccion: 'Reino Unido',
          objetivos: 6411, totalProcesado: 18790, ultimaActualizacion: corte),
      ListaSource(id: 'canada', nombre: 'Canadá', jurisdiccion: 'Canadá',
          objetivos: 5620, totalProcesado: 11328, ultimaActualizacion: corte),
      ListaSource(id: 'australia', nombre: 'Australia', jurisdiccion: 'Australia',
          objetivos: 3898, totalProcesado: 9377, ultimaActualizacion: DateTime(2026, 10, 7)),
      const ListaSource(id: 'suiza-seco', nombre: 'Suiza - SECO', jurisdiccion: 'Suiza'),
    ];
  }

  @override
  Future<List<ListaSource>> obtenerListas() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_listas);
  }

  @override
  Future<ListaSource> agregarLista({
    required String nombre,
    required String jurisdiccion,
    required String urlDescarga,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final nueva = ListaSource(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      nombre: nombre,
      jurisdiccion: jurisdiccion,
      urlDescarga: urlDescarga,
      estado: ListaEstado.actualizando, // el ingestor aún no la descargó
    );
    _listas.add(nueva);
    return nueva;
  }

  @override
  Future<void> eliminarLista(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _listas.removeWhere((l) => l.id == id);
  }
}
