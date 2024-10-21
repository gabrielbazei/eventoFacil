class Usuarioevent {
  int? id;
  int idUsuario;
  int idEvento;
  DateTime? dataEntrada;
  DateTime? dataSaida;
  String hashQR;
  String isAdmin; // Altere para String

  Usuarioevent({
    this.id,
    required this.idUsuario,
    required this.idEvento,
    this.hashQR = "",
    this.isAdmin = "0", // Inicializa como string
    this.dataEntrada,
    this.dataSaida,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'idEvento': idEvento,
      'hashQR': hashQR,
      'isAdmin': isAdmin, // Mantém como string
      'dataEntrada': dataEntrada?.toIso8601String(),
      'dataSaida': dataSaida?.toIso8601String(),
    };
  }

  factory Usuarioevent.fromMap(Map<String, dynamic> map) {
    return Usuarioevent(
      id: map['id'],
      idUsuario: map['idUsuario'],
      idEvento: map['idEvento'],
      hashQR: map['hashQR'],
      isAdmin: map['isAdmin'], // Isso deve ser uma string
      dataEntrada: map['dataEntrada'] != null
          ? DateTime.parse(map['dataEntrada'])
          : null,
      dataSaida:
          map['dataSaida'] != null ? DateTime.parse(map['dataSaida']) : null,
    );
  }
}
