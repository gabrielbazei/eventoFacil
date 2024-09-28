class Aluno {
  final String id;

  Aluno({required this.id});

  // Método para representar o objeto Aluno como String, se necessário
  @override
  String toString() {
    return 'Aluno{id: $id}';
  }
}
