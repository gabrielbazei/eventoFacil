/*import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

String idAluno() {
  return '123';
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code do aluno'),
        centerTitle: true,
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
              margin: const EdgeInsets.all(20),
              child: QrImageView(
                data: idAluno(),
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              )),
        ),
      ]),
    );
  }
}*/
