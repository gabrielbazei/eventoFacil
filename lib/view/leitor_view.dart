import 'package:eventofacil/presenter/leitor_presenter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  BarcodeScannerSimpleState createState() => BarcodeScannerSimpleState();
}

class BarcodeScannerSimpleState extends State<BarcodeScannerSimple>
    implements BarcodeScannerView {
  late BarcodeScannerPresenter _presenter;
  String? _barcodeValue;

  @override
  void initState() {
    super.initState();
    _presenter = BarcodeScannerPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanear o qr code')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcodeCapture) {
              _presenter.handleBarcode(barcodeCapture, context);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcodeDisplay())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para exibir a informação do código QR na UI
  Widget _buildBarcodeDisplay() {
    if (_barcodeValue == null) {
      return const Text(
        'Scaneie o codigo do aluno!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Text(
        _barcodeValue ?? 'Nenhum valor no display',
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      );
    }
  }

  @override
  void updateBarcodeDisplay(String? barcodeValue) {
    setState(() {
      _barcodeValue = barcodeValue;
    });
  }

  @override
  void returnToDashboard() {
    Navigator.pop(context);
  }
}
