import 'package:eventofacil/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  void salvarCodigo(String? codigo) {
    print(codigo);
  }

  Widget test(BuildContext context) {
    if (_barcode != null) {
      salvarCodigo(_barcode?.displayValue);
      // TODO: verificar uma maneira melhor de voltar para a tela inicial, caso não encontre, validar se o ID do aluno ja pertence a lista de alunos daquele evento
      Navigator.pop(context);
    }

    // Retorna o widget quando _barcode é nulo
    return _buildBarcode(_barcode);
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scaneie o codigo do aluno!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Text(
        value.displayValue ?? 'Nenhum valor no display',
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      );
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanear o qr code')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
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
                  Expanded(child: Center(child: test(context))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
