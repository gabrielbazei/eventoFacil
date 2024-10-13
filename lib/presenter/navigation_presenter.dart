import 'package:eventofacil/model/navigation_model.dart';
import 'package:eventofacil/view/event_view.dart';
import 'package:flutter/material.dart';

abstract class NavigationView {
  void updateView(int index);
}

class NavigationPresenter {
  final NavigationView view;
  int currentPageIndex = 0;

  final List<Event> events = [
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

  List<Event> getSubscribedEvents() {
    return events.where((event) => event.isSubscribed).toList();
  }

  void onShowQrCode(Event event) {
    print('Mostrar QR Code para ${event.title}');
    // Lógica para exibir o QR Code para o evento
  }

  void onPageSelected(int index) {
    currentPageIndex = index;
    view.updateView(index);
  }

  void onEventSelected(context, Event event) {
    print('${event.title} clicado!');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventoScreen(
                  evento: event,
                )));
  }
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

  void onJoinEvent(Event event) {
    print('Participar do ${event.title}');
    // Adicione a lógica necessária para o usuário se inscrever no evento
  }

  void onCancelEvent(Event event) {
    print('Cancelamento do ${event.title}');
  }

  List<Event> getEvents() => events;
}
