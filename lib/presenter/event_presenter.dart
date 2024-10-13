import '../model/navigation_model.dart';

class EventoPresenter {
  final EventoView view;
  Event evento;

  EventoPresenter(this.evento, this.view);

  void carregarEvento() {
    // Simula a carga de dados do evento.
    view.mostrarEvento(evento);
  }

  void salvarEvento() {
    // Lógica para salvar o evento
    print("Evento salvo: ${evento.title}");
    view.mostrarMensagem('Evento salvo com sucesso!');
  }

  void apagarEvento() {
    // Lógica para apagar o evento
    print("Evento apagado: ${evento.title}");
    view.mostrarMensagem('Evento apagado com sucesso!');
  }
}

// Interface para que a View possa implementar
abstract class EventoView {
  void mostrarEvento(Event evento);
  void mostrarMensagem(String mensagem);
}
