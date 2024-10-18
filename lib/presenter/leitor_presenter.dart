import 'package:eventofacil/view/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

abstract class BarcodeScannerView {
  void updateBarcodeDisplay(String? barcodeValue);
  void returnToDashboard();
}

class BarcodeScannerPresenter {
  final BarcodeScannerView view;
  Barcode? _currentBarcode;
  bool _isProcessing = false; // Adicionado para controlar leituras múltiplas

  BarcodeScannerPresenter(this.view);

  // Método chamado quando um novo código QR é detectado
  void handleBarcode(BarcodeCapture barcodes, BuildContext context) {
    if (_isProcessing) return; // Ignorar leituras enquanto já está processando

    _currentBarcode = barcodes.barcodes.firstOrNull;
    if (_currentBarcode != null) {
      _isProcessing = true; // Marcar como processando
      view.updateBarcodeDisplay(_currentBarcode?.displayValue);
      salvarCodigo(_currentBarcode?.displayValue);
      navigateToDashboard(context);
    }
  }

  // Método para salvar o código (pode ser expandido para persistência no futuro)
  void salvarCodigo(String? codigo) {
    //TODO enviar o codigo vindo do leitor para o banco
    print('Código salvo: $codigo');
  }

  void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationExample()),
    ).then((_) {
      _isProcessing = false; // Resetar o estado de processamento ao voltar
    });
  }
}
