import 'package:intl/intl.dart';

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

  void salvarEvento() {
    // Lógica para salvar o evento
    view.mostrarMensagem('Evento salvo com sucesso!');
  }

  void apagarEvento() {
    // Lógica para apagar o evento
    print("Evento apagado: ${evento.nomeEvento}");
    view.mostrarMensagem('Evento apagado com sucesso!');
  }

  void adicionarEvento() {}

  void onEventDelete() {}

  String formataData(DateTime? data) {
    if (data != null) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
      String formattedDate = formatter.format(data);
      return formattedDate;
    } else {
      return "";
    }
  }
}

// Interface para que a View possa implementar
abstract class EventoView {
  void mostrarEvento(Event evento);
  void mostrarMensagem(String mensagem);
}
