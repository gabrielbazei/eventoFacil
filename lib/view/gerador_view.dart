import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:eventofacil/presenter/gerador_presenter.dart';

class GenerateQRCode extends StatefulWidget {
  final String hashQR;
  const GenerateQRCode(String this.hashQR, {super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode>
    implements GenerateQRCodeView {
  late GenerateQRCodePresenter _presenter;
  String qrData = '';

  @override
  void initState() {
    super.initState();
    _presenter = GenerateQRCodePresenter(this);
    _presenter.loadQRCode(widget.hashQR); // Carrega o QR code inicial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code do aluno'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: qrData.isNotEmpty
                  ? QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                    )
                  : const CircularProgressIndicator(), // Indicador de carregamento
            ),
          ),
        ],
      ),
    );
  }

  @override
  void updateQRCode(String qrData) {
    setState(() {
      this.qrData = qrData;
    });
  }
}
