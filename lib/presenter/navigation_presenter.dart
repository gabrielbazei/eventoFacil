import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:eventofacil/dao/usuario_dao.dart';
import 'package:eventofacil/model/event_model.dart';
import 'package:eventofacil/model/usuario_event_model.dart';
import 'package:eventofacil/model/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../dao/evento_dao.dart';
import '../dao/usuario_event_dao.dart';
import '../view/event_view.dart';
import '../view/login_view.dart';
import '../view/troca_senha_view.dart';

abstract class NavigationView {
  void updateView(int index);
}

class NavigationPresenter {
  final NavigationView view;
  int currentPageIndex = 0;
  NavigationPresenter(this.view);
  List<Usuarioevent> userEvent = [];
  List<Event>? events = [];
  Usuario? user = Usuario(id: -1);
  //Função para carregar os dados do usuário e dos eventos de forma inicial
  Future<void> load(String login) async {
    user = await UsuarioDAO().buscarUsuarioPorCpf(login);
    events = await EventDAO().listarEventos();
    if (user?.id != null) {
      userEvent = await UsuarioEventDAO().listarEventosPorUsuario(user!.id);
    }
  }

  //Função para retornar a lista de eventos inscritos para montar a carteira.
  List<Usuarioevent> getSubscribedEvents() {
    List<Usuarioevent> temp = [];
    for (Usuarioevent evento in userEvent) {
      //Verifica se o evento é do usuário logado
      if (evento.idUsuario == user?.id) {
        temp.add(evento);
      }
    }
    return temp;
  }

  //Função que serve para montar a estrutura de navegação da tela principal do APP
  void onPageSelected(int index) {
    //Utiliza o valor passado para atualizar pela chamada para atualizar a view.
    currentPageIndex = index;
    view.updateView(index);
  }

  //Função para encaminhar o evento para a pagina de eventos.
  //Esta função passa todas as informações do evento, inclusive se ele é admin e inscrito.
  void onEventSelected(context, Event event) {
    String isAdmin = "0";
    for (Usuarioevent evento in userEvent) {
      if (evento.idEvento == event.id) {
        isAdmin = evento.isAdmin;
      }
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  cpf: user!.cpf,
                  id: user!.id,
                  evento: event,
                  isNew: false,
                  isAdmin: isAdmin,
                )));
  }

//Função para inscrever o usuário no evento
  Future<void> onJoinEvent(Event event, context) async {
    // Cria um novo Usuarioevent
    Usuarioevent usuarioEvent = Usuarioevent(
        idUsuario: user!.id,
        idEvento: event.id ?? -1,
        hashQR: "0",
        isAdmin: "0");
    // Gera a hash SHA-256
    String input = user!.cpf + event.id.toString(); // Concatena o cpf e o id
    var bytes = utf8.encode(input); // Converte a string para bytes
    var digest = sha256.convert(bytes); // Gera a hash SHA-256
    usuarioEvent.hashQR = digest.toString();
    try {
      // Insere o usuário no evento
      int codigo = await UsuarioEventDAO().inserirUsuarioEvent(usuarioEvent);
      if (codigo == 200) {
        _showAlert(
            context, "Sucesso", "Você se inscreveu no evento com sucesso!");
      } else {
        _showAlert(
            context, "Erro", "Ocorreu um erro ao se inscrever no evento.");
      }
      view.updateView(currentPageIndex);
    } catch (e) {
      print(e);
    }
  }

  //Função para cancelar a inscrição do usuário no evento
  void onCancelEvent(Usuarioevent evento, BuildContext context) async {
    try {
      int codigo = await UsuarioEventDAO().deletarUsuarioEvent(evento.id ?? -1);
      if (codigo == 200) {
        _showAlert(context, "Sucesso", "Você cancelou a inscrição no evento!");
      } else {
        _showAlert(context, "Erro", "Ocorreu um erro ao cancelar a inscrição.");
      }
      view.updateView(currentPageIndex);
    } catch (e) {
      print(e);
    }
  }

  //Função para retornar a lista de eventos
  Future<List<Event>> getEvents() async {
    EventDAO eventDAO = EventDAO(); // Inicializando o eventDAO
    Future<List<Event>> events = eventDAO.listarEventos();
    return events;
  }

  //Função para criar um novo evento
  void onCreateEvent(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  cpf: user!.cpf,
                  id: user!.id,
                  evento: Event(),
                  isNew: true, // Indica que é um novo evento
                  isAdmin:
                      "1", // O usuário que cria o evento é automaticamente admin
                )));
  }

  //Função para realizar o logout do usuário
  Future<void> onLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'isLoggedIn', false); // Define o estado de login como falso
    await prefs.setString('cpf', ""); // Limpa o cpf salvo

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  //Função para alterar a senha do usuário
  void onPasswordChage(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const TrocaSenhaPage()));
  }

  //Função para salvar os dados do usuário
  Future<void> onSave(
      context,
      String? nome,
      String? email,
      String? phone,
      String? address,
      String? number,
      String? city,
      DateTime? birthDate,
      String? selectedGender) async {
    int codigo = 0;
    if (user != null &&
        nome != null &&
        email != null &&
        phone != null &&
        address != null &&
        number != null &&
        city != null &&
        birthDate != null &&
        selectedGender != null) {
      user?.nome = nome;
      user?.email = email;
      user?.telefone = phone;
      user?.endereco = address;
      user?.numEndereco = number;
      user?.cidade = city;
      user?.dataNascimento = birthDate;
      user?.genero = selectedGender;
      codigo = await UsuarioDAO().atualizarUsuario(user!);
      if (codigo == 200) {
        _showAlert(context, 'Sucesso', 'Os dados foram salvos com sucesso!');
      } else {
        _showAlert(context, 'Erro', 'Ocorreu um erro ao salvar os dados.');
      }
    }
    view.updateView(currentPageIndex);
  }

  //Função para formatar a data para o padrão brasileiro
  String formataData(DateTime dataInicio) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    String formattedDate = formatter.format(dataInicio);
    return formattedDate;
  }

  //Função para verificar se o usuário é admin
  bool checkAdmin(int? id) {
    for (Usuarioevent evento in userEvent) {
      if (evento.idEvento == id &&
          evento.idUsuario == user?.id &&
          evento.isAdmin == "1") {
        return true; // Retorna verdadeiro se o usuário é admin
      }
    }
    return false; // Retorna falso se não encontrou um admin
  }

  //Função para verificar se o evento existe
  bool checkExist(int? id) {
    for (Usuarioevent evento in userEvent) {
      if (evento.idEvento == id && evento.idUsuario == user?.id) {
        return true; // Retorna verdadeiro se o evento existe
      }
    }
    return false;
  }

  //Função para retornar o evento
  Event getEvent(int? id) {
    Event temp = Event();
    for (Event evento in events!) {
      if (evento.id == id) {
        temp = evento;
      }
    }
    return temp;
  }

  //Função para retornar o usuário
  Usuario getUsuario() {
    return user ??
        (throw Exception(
            "Usuario não encontrado")); // Lança exceção se user for nulo
  }

  //Função para mostrar um alerta
  void _showAlert(BuildContext context, String title, String message) {
    // Use a função `showDialog` com um contexto válido
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

  //Função para verificar se o usuário é organizador
  Future<bool> isOrganizador() async {
    if (user?.id == -1) {
      await load(
          user!.cpf); // Carrega os dados do usuário se não estiverem carregados
    }
    if (user?.isOrganizador == "1") {
      return true;
    } else {
      return false;
    }
  }
}
