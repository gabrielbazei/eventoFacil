import 'package:flutter/material.dart';

class EventoScreen extends StatelessWidget {
  final bool isAdmin; // Variável para definir se o usuário é admin ou não
  final int id;
  EventoScreen(this.isAdmin, this.id);

  @override
  Widget build(BuildContext context) {
    // Controladores de texto para os campos do formulário
    TextEditingController eventoController = TextEditingController();
    TextEditingController localController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();
    TextEditingController dataInicioController = TextEditingController();
    TextEditingController dataFimController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: eventoController,
              enabled: isAdmin,
              decoration: InputDecoration(labelText: 'Evento'),
            ),
            TextField(
              controller: localController,
              enabled: isAdmin,
              decoration: InputDecoration(labelText: 'Local'),
            ),
            TextField(
              controller: descricaoController,
              enabled: isAdmin,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: dataInicioController,
              enabled: isAdmin,
              decoration: InputDecoration(labelText: 'Data Início'),
            ),
            TextField(
              controller: dataFimController,
              enabled: isAdmin,
              decoration: InputDecoration(labelText: 'Data Fim'),
            ),
            const SizedBox(height: 20),
            if (isAdmin) ...[
              ElevatedButton(
                onPressed: () {
                  // Lógica para salvar o evento
                  print("evento $id salvo");
                },
                child: Text('Salvar'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Lógica para apagar o evento
                  print("evento $id apagado");
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: Text('Apagar Evento'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
