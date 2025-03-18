class Score {
  final int? id;
  final String nombre;
  final int puntos;

  Score({this.id, required this.nombre, required this.puntos});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'puntos': puntos,
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      nombre: map['nombre'],
      puntos: map['puntos'],
    );
  }
}