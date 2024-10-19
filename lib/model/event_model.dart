class Event {
  int? id;
  String nomeEvento;
  String descricao;
  String local;
  DateTime dataInicio;
  DateTime? dataFim;
  bool isAdmin; //Indica se o usuario é admin no evento
  bool isSubscribed; // Indica se o usuário está inscrito no evento
  Event({
    this.nomeEvento = "",
    this.descricao = "",
    this.local = "",
    this.isAdmin = false,
    this.isSubscribed = false,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) : dataInicio = dataInicio ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nomeEvento': nomeEvento,
      'descricao': descricao,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'local': local,
    };
  }
}
