import 'package:eventofacil/model/event_model.dart';
import 'package:flutter/material.dart';
import '../presenter/event_presenter.dart';

class EventoScreen extends StatefulWidget {
  final Event evento;
  final bool isNew;
  final String isAdmin;

  const EventoScreen({
    super.key,
    required this.evento,
    required this.isNew,
    required this.isAdmin,
  });

  @override
  _EventoScreenState createState() => _EventoScreenState();
}

class _EventoScreenState extends State<EventoScreen> implements EventoView {
  late EventoPresenter presenter;
  late bool admin;
  late Event evento;

  final TextEditingController eventoController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFimController = TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = EventoPresenter(widget.evento, this);
    evento = presenter.carregarEvento();
    admin = widget.isAdmin == "1";
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
              enabled: admin,
              decoration: InputDecoration(
                labelText: 'Evento',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: localController,
              enabled: admin,
              decoration: InputDecoration(
                labelText: 'Local',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descricaoController,
              enabled: admin,
              maxLines: 3, // Permite pelo menos 3 linhas
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dataInicioController,
                    enabled: admin,
                    decoration: InputDecoration(
                      labelText: 'Data de início',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: evento.dataInicio ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        dataInicioController.text =
                            '${pickedDate.toLocal()}'.split(' ')[0];
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                if (evento.dataFim != null || admin || widget.isNew) ...[
                  Expanded(
                    child: TextFormField(
                      controller: dataFimController,
                      enabled: admin,
                      decoration: InputDecoration(
                        labelText: 'Data de finalização',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: evento.dataFim ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          dataFimController.text =
                              '${pickedDate.toLocal()}'.split(' ')[0];
                        }
                      },
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 20),
            if (widget.isNew) ...[
              ElevatedButton(
                onPressed: criarEvento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(73, 149, 180, 1),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Salvar'),
              ),
            ] else if (!widget.isNew && admin) ...[
              ElevatedButton(
                onPressed: presenter.salvarEvento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(73, 149, 180, 1),
                  foregroundColor: Colors.white,
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
                  foregroundColor: Colors.white,
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
      dataInicioController.text =
          presenter.formataData(widget.evento.dataInicio);
      dataFimController.text = presenter.formataData(widget.evento.dataFim);
    });
  }

  @override
  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void criarEvento() {
    Event evento = Event();
    evento.nomeEvento = eventoController.text;
    evento.descricao = descricaoController.text;
    evento.local = localController.text;
    presenter.adicionarEvento();
  }
}
