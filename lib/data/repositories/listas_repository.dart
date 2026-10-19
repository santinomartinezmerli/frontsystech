import 'package:pf_systech_frontend/domain/models/lista_source.dart';

/// Contrato para obtener el catálogo de listas.
/// Hoy lo implementa un mock; después se reemplaza por llamadas al backend.
abstract class ListasRepository {
  Future<List<ListaSource>> obtenerListas();
}

/// DATOS MOCK. Cifras tomadas del catálogo técnico de Systech
/// (corte 16/10/2026; Australia 07/10). Son de OpenSanctions, no oficiales.
class ListasMockRepository implements ListasRepository {
  @override
  Future<List<ListaSource>> obtenerListas() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
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
}
