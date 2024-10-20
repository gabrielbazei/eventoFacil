class Event {
  int? id;
  String nomeEvento;
  String descricao;
  String local;
  DateTime dataInicio;
  DateTime? dataFim;
  bool isAdmin; //Indica se o usuario é admin no evento
  bool? isSubscribed; // Indica se o usuário está inscrito no evento
  Event({
    this.id = null,
    this.nomeEvento = "",
    this.descricao = "",
    this.local = "",
    this.isAdmin = false,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) : dataInicio = dataInicio ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeEvento': nomeEvento,
      'descricao': descricao,
      'local': local,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim?.toIso8601String(),
      'isAdmin': isAdmin ? 1 : 0,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      nomeEvento: map['nomeEvento'],
      descricao: map['descricao'],
      local: map['local'],
      dataInicio: DateTime.parse(map['dataInicio']),
      dataFim: map['dataFim'] != null ? DateTime.parse(map['dataFim']) : null,
      isAdmin: map['isAdmin'] == 1,
    );
  }
}
