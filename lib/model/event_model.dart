class Event {
  int? id;
  String nomeEvento;
  String descricao;
  String local;
  DateTime dataInicio;
  DateTime? dataFim;
  Event({
    this.id = null,
    this.nomeEvento = "",
    this.descricao = "",
    this.local = "",
    DateTime? dataInicio,
    DateTime? dataFim,
  }) : dataInicio = dataInicio ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idevent': id,
      'nomeEvento': nomeEvento,
      'descricao': descricao,
      'local': local,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim?.toIso8601String(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['idevent'],
      nomeEvento: map['nomeEvento'],
      descricao: map['descricao'],
      local: map['local'],
      dataInicio: DateTime.parse(map['dataInicio']),
      dataFim: map['dataFim'] != null ? DateTime.parse(map['dataFim']) : null,
    );
  }
}
