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
      if (evento.idUsuario == user?.id) {
        temp.add(evento); // Retorna verdadeiro se o usuário é admin
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
      if (evento.id == event.id) {
        isAdmin = evento.isAdmin;
      }
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  evento: event,
                  isNew: false,
                  isAdmin: isAdmin,
                )));
  }

  //Altera o valor do "isSubscribed" para true
  void onJoinEvent(Event event) {
    //event.isSubscribed = true;
    // Atualiza a visualização para refletir a alteração
    view.updateView(currentPageIndex);
    //TODO: adicionar a função para inserir no banco de dados
  }

  //Altera o valor do "isSubscribed" para false
  void onCancelEvent() {
    //event.isSubscribed = false;
    // Atualiza a visualização para refletir a alteração
    view.updateView(currentPageIndex);
    //TODO: adicionar a função para remover do banco de dados
  }

  Future<List<Event>> getEvents() async {
    EventDAO eventDAO = EventDAO(); // Inicializando o eventDAO
    Future<List<Event>> events = eventDAO
        .listarEventos(); // Supondo que listarEventos() retorne uma List<Event>
    return events;
  }

  //Encaminha o usuario para a pagina de eventos passando
  void onCreateEvent(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  evento: Event(),
                  isNew: true,
                  isAdmin: "1",
                )));
  }

  Future<void> onLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('cpf', "");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void onPasswordChage(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const TrocaSenhaPage()));
  }

  void onSave(String? phone, String? address, String? number, String? city,
      DateTime? birthDate, String? selectedGender) {
    if (user != null &&
        phone != null &&
        address != null &&
        number != null &&
        city != null &&
        birthDate != null &&
        selectedGender != null) {
      user?.telefone = phone;
      user?.endereco = address;
      user?.numEndereco = number;
      user?.cidade = city;
      user?.dataNascimento = birthDate;
      user?.genero = selectedGender;
      UsuarioDAO().atualizarUsuario(user!);
    }
    view.updateView(currentPageIndex);
  }

  String formataData(DateTime dataInicio) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    String formattedDate = formatter.format(dataInicio);
    return formattedDate;
  }

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

  bool checkExist(int? id) {
    for (Usuarioevent evento in userEvent) {
      if (evento.idEvento == id && evento.idUsuario == user?.id) {
        return true; // Retorna verdadeiro se o usuário é admin
      }
    }
    return false;
  }

  Event getEvent(int? id) {
    Event temp = Event();
    for (Event evento in events!) {
      if (evento.id == id) {
        temp = evento;
      }
    }
    return temp;
  }

  Usuario getUsuario() {
    return user ??
        (throw Exception(
            "Usuario não encontrado")); // Lança exceção se user for nulo
  }
}
