import 'package:eventofacil/model/navigation_model.dart';

abstract class NavigationView {
  void updateView(int index);
}

class NavigationPresenter {
  final NavigationView view;
  int currentPageIndex = 0;

  // Exemplo de lista de eventos
  final List<Event> events = [
    Event(title: 'Evento 1', description: 'Descrição do Evento 1'),
    Event(title: 'Evento 2', description: 'Descrição do Evento 2'),
    Event(title: 'Evento 3', description: 'Descrição do Evento 3'),
  ];

  NavigationPresenter(this.view);

  void onPageSelected(int index) {
    currentPageIndex = index;
    view.updateView(index);
  }

  void onEventSelected(String eventTitle) {
    print('$eventTitle clicado!');
  }

  List<Event> getEvents() => events;
}
