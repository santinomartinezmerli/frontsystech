/// Estado de una lista según lo que reporta el ingestor.
enum ListaEstado { activa, actualizando, error }

/// Lista de antecedentes provista y cargada por Systech (OFAC, ONU, etc.).
/// Los clientes (bancos) no cargan listas: solo las consumen vía packs.
class ListaSource {
  final String id;
  final String nombre;
  final String jurisdiccion;

  /// Sujetos sancionados (clasificación "Targets" de OpenSanctions).
  /// null = sin cifra validada.
  final int? objetivos;

  /// Total procesado, incluye entidades auxiliares (domicilios, etc.).
  final int? totalProcesado;

  final DateTime? ultimaActualizacion;
  final ListaEstado estado;

  const ListaSource({
    required this.id,
    required this.nombre,
    required this.jurisdiccion,
    this.objetivos,
    this.totalProcesado,
    this.ultimaActualizacion,
    this.estado = ListaEstado.activa,
  });
}
