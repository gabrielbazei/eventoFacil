import 'package:eventofacil/dao/usuario_event_dao.dart';
import 'package:eventofacil/model/usuario_event_model.dart';
import 'package:eventofacil/view/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

abstract class BarcodeScannerView {
  void updateBarcodeDisplay(String? barcodeValue);
  void returnToDashboard();
}

class BarcodeScannerPresenter {
  final BarcodeScannerView view;
  final String cpf;
  Barcode? _currentBarcode;
  bool _isProcessing = false; // Adicionado para controlar leituras múltiplas

  BarcodeScannerPresenter(this.view, this.cpf);

  // Método chamado quando um novo código QR é detectado
  void handleBarcode(BarcodeCapture barcodes, BuildContext context) {
    if (_isProcessing) return; // Ignorar leituras enquanto já está processando

    _currentBarcode = barcodes.barcodes.firstOrNull;
    if (_currentBarcode != null) {
      _isProcessing = true; // Marcar como processando
      view.updateBarcodeDisplay(_currentBarcode?.displayValue);
      salvarCodigo(_currentBarcode?.displayValue, context);
      navigateToDashboard(context);
    }
  }

  // Método para salvar o código lido no banco de dados
  Future<void> salvarCodigo(String? codigo, context) async {
    if (codigo == null) return;
    List<Usuarioevent> usuarioevent =
        await UsuarioEventDAO().listarEventosPorHash(codigo);
    // Verificar se o usuário já entrou e/ou saiu do evento
    if (usuarioevent.isNotEmpty) {
      Usuarioevent ue = usuarioevent.first;
      // Atualizar a data de entrada ou saída do usuário
      if (ue.dataEntrada == null) {
        ue.dataEntrada = DateTime.now();
        await UsuarioEventDAO().atualizarUsuarioEvent(ue);
      } else if (ue.dataSaida == null) {
        ue.dataSaida = DateTime.now();
        await UsuarioEventDAO().atualizarUsuarioEvent(ue);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Uusário já saiu do evento"),
              content: Text("O usuário já saiu do evento."),
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
  }

  void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard(cpf)),
    ).then((_) {
      _isProcessing = false; // Resetar o estado de processamento ao voltar
    });
  }
}
