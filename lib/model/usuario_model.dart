class Usuario {
  int id;
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
    required this.id,
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
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'senha': senha,
      'telefone': telefone,
      'endereco': endereco,
      'numEndereco': numEndereco,
      'cidade': cidade,
      'genero': genero,
      'dataNascimento': dataNascimento.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['idUsuario'] ?? -1, // Ou outro valor padrão que você queira
      nome: map['nome'] ?? "",
      email: map['email'] ?? "",
      cpf: map['cpf'] ?? "",
      senha: map['senha'] ?? "",
      telefone: map['telefone'] ?? "",
      endereco: map['endereco'] ?? "",
      numEndereco: map['numEndereco'] ?? "",
      cidade: map['cidade'] ?? "",
      genero: map['genero'] ?? "",
      dataNascimento: map['dataNascimento'] != null
          ? DateTime.parse(map['dataNascimento'])
          : DateTime.now(),
    );
  }
}
