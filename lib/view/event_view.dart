import 'package:eventofacil/model/event_model.dart';
import 'package:flutter/material.dart';
import '../presenter/event_presenter.dart';

class EventoScreen extends StatefulWidget {
  final Event evento;
  final bool isNew;

  const EventoScreen({
    super.key,
    required this.evento,
    required this.isNew,
  });

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
        title: const Text('Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: eventoController,
              enabled: widget.evento.isAdmin,
              decoration: const InputDecoration(labelText: 'Evento'),
              style: const TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: localController,
              enabled: widget.evento.isAdmin,
              decoration: const InputDecoration(labelText: 'Local'),
              style: const TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: descricaoController,
              enabled: widget.evento.isAdmin,
              decoration: const InputDecoration(labelText: 'Descrição'),
              style: const TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: dataInicioController,
              enabled: widget.evento.isAdmin,
              decoration: const InputDecoration(labelText: 'Data Início'),
              style: const TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: dataFimController,
              enabled: widget.evento.isAdmin,
              decoration: const InputDecoration(labelText: 'Data Fim'),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (widget.isNew) ...[
              ElevatedButton(
                onPressed: criarEvento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(73, 149, 180, 1),
                  foregroundColor: Colors.white, // Cor do texto
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Salvar'),
              ),
            ] else if (widget.evento.isAdmin && !widget.isNew) ...[
              ElevatedButton(
                onPressed: presenter.salvarEvento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(73, 149, 180, 1),
                  foregroundColor: Colors.white, // Cor do texto
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: presenter.onEventDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, // Cor do texto
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Apagar Evento'),
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
      eventoController.text = evento.nomeEvento;
      localController.text = evento.local;
      descricaoController.text = evento.descricao;
      dataInicioController.text = widget.evento.dataInicio.toIso8601String();
      dataFimController.text = widget.evento.dataFim.toString();
    });
  }

  @override
  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void criarEvento() {
    Event evento = Event(isAdmin: true);
    evento.nomeEvento = eventoController.text;
    evento.descricao = descricaoController.text;
    evento.local = localController.text;
    presenter.adicionarEvento();
  }
}
