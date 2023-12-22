class Points {
  final int points;

  Points({
    required this.points,
  });

  static Points fromJson(Map<String, dynamic> json) {
    return Points(
      points: json['puntos'],
    );
  }

  static Map<String, dynamic> queryPoints(String plan, String transaccion) {
    return {
      'query': '''query MyQuery {
        listPuntosAfiliacionesSAPOS(limit:1000, filter: {cooperativa: {eq: "Benefica"}, plan: {contains: "$plan"}, transaccion: {eq: "$transaccion"}}) {
          items {
            puntos
          }
        }
      }'''
    };
  }
}
