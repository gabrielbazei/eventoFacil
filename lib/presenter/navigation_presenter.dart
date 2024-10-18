import 'package:eventofacil/model/navigation_model.dart';
import 'package:eventofacil/view/event_view.dart';
import 'package:flutter/material.dart';

abstract class NavigationView {
  void updateView(int index);
}

class NavigationPresenter {
  final NavigationView view;
  int currentPageIndex = 0;

  //Gera uma lista de eventos generica. Adicionando alguns atributos para simular
  //TODO: remover esta função assim que um SQL for criado.
  List<Event> events = [
    Event(
        title: 'Evento 1',
        description: 'Descrição do Evento 1',
        isAdmin: true,
        isSubscribed: true),
    Event(
        title: 'Evento 2',
        description: 'Descrição do Evento 2',
        isAdmin: false,
        isSubscribed: false),
    Event(
        title: 'Evento 3',
        description: 'Descrição do Evento 3',
        isAdmin: false,
        isSubscribed: true),
  ];

  NavigationPresenter(this.view);

  //Função para retornar a lista de eventos inscritos para montar a carteira.
  List<Event> getSubscribedEvents() {
    return events.where((event) => event.isSubscribed).toList();
  }

  //TODO: remover função não utilizada
  /*void onShowQrCode(Event event) {
    print('Mostrar QR Code para ${event.title}');
    // Lógica para exibir o QR Code para o evento
  }*/
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

  //TODO: remover função não utilizada
  /*void onEditEvent(context, Event event) {
    print('Editar ${event.title}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  evento: event,
                )));
    // Aqui você pode adicionar a lógica para a edição do evento
  }*/
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
}
