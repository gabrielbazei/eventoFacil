class Usuario {
  String nome;
  String email;
  String cpf;
  String senha;
  String telefone;
  String endereco;
  String numEndereco;
  String cidade;
  DateTime dataNascimento;
  String genero;
  Usuario({
    this.nome = "",
    this.email = "",
    this.cpf = "",
    this.senha = "",
    this.telefone = "",
    this.endereco = "",
    this.numEndereco = "",
    this.cidade = "",
    this.genero = "",
    DateTime? dataNascimento,
  }) : dataNascimento = dataNascimento ?? DateTime.now();

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
