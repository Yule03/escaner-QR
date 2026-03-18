enum TipoQR { url, wifi, texto, contacto }

class EscaneoQR {
  final String contenido;
  final DateTime fechaHora;
  final TipoQR tipo;

  EscaneoQR({
    required this.contenido,
    required this.tipo,
    DateTime? fechaHora,
  }) : fechaHora = fechaHora ?? DateTime.now();

  // Factory constructor para crear desde texto (escanear)
  factory EscaneoQR.fromTexto(String texto) {
    final tipo = texto.startsWith('http')
        ? TipoQR.url
        : texto.startsWith('WIFI:')
            ? TipoQR.wifi
            : TipoQR.texto;
    return EscaneoQR(contenido: texto, tipo: tipo);
  }

  // Métodos para persistencia
  Map<String, dynamic> toJson() => {
        'contenido': contenido,
        'fechaHora': fechaHora.toIso8601String(),
        'tipo': tipo.index,
      };

  factory EscaneoQR.fromJson(Map<String, dynamic> json) => EscaneoQR(
        contenido: json['contenido'],
        fechaHora: DateTime.parse(json['fechaHora']),
        tipo: TipoQR.values[json['tipo']],
      );

  @override
  String toString() => '[' + tipo.name.toUpperCase() + '] ' + contenido;
}
