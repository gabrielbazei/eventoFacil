import 'package:eventofacil/model/navigation_model.dart';
import 'package:flutter/material.dart';
import '../presenter/event_presenter.dart';

class EventoScreen extends StatefulWidget {
  final Event evento;

  EventoScreen({required this.evento}); // Recebe o objeto Event pelo construtor

  @override
  _EventoScreenState createState() => _EventoScreenState();
}

class _EventoScreenState extends State<EventoScreen> implements EventoView {
  late EventoPresenter presenter;

  // Controladores de texto para os campos do formulário
  final TextEditingController eventoController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFimController = TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = EventoPresenter(widget.evento, this);
    presenter.carregarEvento();
  }

  @override
  Widget build(BuildContext context) {
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
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Evento'),
            ),
            TextField(
              controller: localController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Local'),
            ),
            TextField(
              controller: descricaoController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: dataInicioController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Data Início'),
            ),
            TextField(
              controller: dataFimController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Data Fim'),
            ),
            const SizedBox(height: 20),
            if (widget.evento.isAdmin) ...[
              ElevatedButton(
                onPressed: presenter.salvarEvento,
                child: Text('Salvar'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: presenter.apagarEvento,
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

  @override
  void mostrarEvento(Event evento) {
    setState(() {
      eventoController.text = evento.title;
      localController.text = evento.location;
      descricaoController.text = evento.description;
      dataInicioController.text = widget.evento.startDate.toString();
      dataFimController.text = widget.evento.endDate.toString();
    });
  }

  @override
  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }
}
