import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eventofacil/dao/evento_dao.dart';
import 'package:eventofacil/model/usuario_event_model.dart';
import 'package:eventofacil/model/usuario_model.dart';
import 'package:eventofacil/view/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dao/usuario_event_dao.dart';
import '../model/event_model.dart';

class EventoPresenter {
  final EventoView view;
  Event evento;

  EventoPresenter(this.evento, this.view);
  //Carrega os dados do evento para a view
  Event carregarEvento() {
    view.mostrarEvento(evento);
    return evento;
  }

  void salvarEvento(Event evento, BuildContext context, String cpf) {
    if (evento.id != null) {
      EventDAO().atualizarEvento(evento);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard(cpf)));
    } else {
      view.mostrarMensagem('Erro: ID do evento é nulo.');
    }
  }

  Future<void> adicionarEvento(
      context, Event evento, String cpf, int id) async {
    int codigouserevent = 200;
    Usuarioevent usuarioevent = Usuarioevent(
      idUsuario: id,
      idEvento: 0, // Inicialmente 0, será atualizado depois
      isAdmin: '1',
      hashQR: cpf,
    );

    // Inserir evento e obter a resposta
    final response = await EventDAO().inserirEvento(evento);
    final responseBody = jsonDecode(response);

    // Pegar o id do evento criado
    final int eventId = responseBody['id'];
    usuarioevent.idEvento = eventId;
    String input = cpf + eventId.toString(); // Concatena o cpf e o id
    var bytes = utf8.encode(input); // Converte a string para bytes
    var digest = sha256.convert(bytes); // Gera a hash SHA-256
    usuarioevent.hashQR = digest.toString();
    // Inserir usuario_evento
    codigouserevent = await UsuarioEventDAO().inserirUsuarioEvent(usuarioevent);

    if (codigouserevent == 200) {
      _showAlert(context, 'Sucesso', 'O evento foi criado com sucesso!');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard(cpf)));
    } else {
      _showAlert(context, 'Erro', 'Ocorreu um erro ao salvar o evento.');
    }
  }

  void onEventDelete(Event evento, BuildContext context, String cpf) {
    if (evento.id != null) {
      EventDAO().deletarEvento(evento.id!);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard(cpf)));
    } else {
      view.mostrarMensagem('Erro: ID do evento é nulo.');
    }
  }

  String formataData(DateTime? data) {
    if (data != null) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
      String formattedDate = formatter.format(data);
      return formattedDate;
    } else {
      return "";
    }
  }

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Interface para que a View possa implementar
abstract class EventoView {
  void mostrarEvento(Event evento);
  void mostrarMensagem(String mensagem);
}
