/// Cliente (banco) con un pack asignado y su consumo actual.
class Cliente {
  final String id;
  final String nombre;
  final bool activo;
  final String? packId;
  final int consultasUsadas;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.activo,
    this.packId,
    this.consultasUsadas = 0,
  });
}
