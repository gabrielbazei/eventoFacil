import 'package:eventofacil/model/event_model.dart';
import 'package:eventofacil/view/event_view.dart';
import 'package:flutter/material.dart';

import '../view/login_view.dart';

abstract class NavigationView {
  void updateView(int index);
}

class NavigationPresenter {
  final NavigationView view;
  int currentPageIndex = 0;

  //Gera uma lista de eventos generica. Adicionando alguns atributos para simular
  //TODO: remover esta função assim que um SQL for criado.
  List<Event> events = [];

  NavigationPresenter(this.view);

  //Função para retornar a lista de eventos inscritos para montar a carteira.
  List<Event> getSubscribedEvents() {
    return events.where((event) => event.isSubscribed).toList();
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  evento: event,
                  isNew: false,
                )));
  }

  //Altera o valor do "isSubscribed" para true
  void onJoinEvent(Event event) {
    event.isSubscribed = true;
    // Atualiza a visualização para refletir a alteração
    view.updateView(currentPageIndex);
    //TODO: adicionar a função para inserir no banco de dados
  }

  //Altera o valor do "isSubscribed" para false
  void onCancelEvent(Event event) {
    event.isSubscribed = false;
    // Atualiza a visualização para refletir a alteração
    view.updateView(currentPageIndex);
    //TODO: adicionar a função para remover do banco de dados
  }

  List<Event> getEvents() => events;
  //Encaminha o usuario para a pagina de eventos passando
  void onCreateEvent(context) {
    Event evento = new Event(isAdmin: true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  evento: evento,
                  isNew: true,
                )));
  }

  void onLogout(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void onPasswordChage() {}

  void onSave(String? phone, String? address, String? number, String? city,
      String? birthDate, String? selectedGender) {}
}
