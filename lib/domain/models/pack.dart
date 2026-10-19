import 'lista_source.dart';

/// Pack: conjunto de listas habilitadas + máximo de consultas.
class Pack {
  final String id;
  final String nombre;

  /// IDs de [ListaSource] habilitadas en este pack.
  final Set<String> listaIds;
  final int maxConsultas;

  const Pack({
    required this.id,
    required this.nombre,
    required this.listaIds,
    required this.maxConsultas,
  });

  Pack copyWith({String? nombre, Set<String>? listaIds, int? maxConsultas}) {
    return Pack(
      id: id,
      nombre: nombre ?? this.nombre,
      listaIds: listaIds ?? this.listaIds,
      maxConsultas: maxConsultas ?? this.maxConsultas,
    );
  }
}
