import 'package:eventofacil/model/event_model.dart';
import 'package:flutter/material.dart';
import '../presenter/event_presenter.dart';

class EventoScreen extends StatefulWidget {
  final Event evento;
  final bool isNew;

  EventoScreen({
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
              style: TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: localController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Local'),
              style: TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: descricaoController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Descrição'),
              style: TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: dataInicioController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Data Início'),
              style: TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: dataFimController,
              enabled: widget.evento.isAdmin,
              decoration: InputDecoration(labelText: 'Data Fim'),
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (widget.isNew) ...[
              ElevatedButton(
                onPressed: criarEvento,
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // Cor do texto
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ] else if (widget.evento.isAdmin && !widget.isNew) ...[
              ElevatedButton(
                onPressed: presenter.salvarEvento,
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // Cor do texto
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: presenter.onEventDelete,
                child: Text('Apagar Evento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, // Cor do texto
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: EdgeInsets.all(16),
                ),
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
    Event evento = new Event(isAdmin: true, isSubscribed: true);
    evento.nomeEvento = eventoController.text;
    evento.descricao = descricaoController.text;
    evento.local = localController.text;
    presenter.adicionarEvento();
  }
}
