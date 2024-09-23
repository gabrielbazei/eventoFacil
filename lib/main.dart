import 'package:eventofacil/gerar.dart';
import 'package:eventofacil/leitor.dart';
import 'package:flutter/material.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.list),
            icon: Icon(Icons.list_outlined),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code),
            label: 'QR code',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Meu perfil',
          ),
        ],
      ),
      body: <Widget>[
        /// Area de eventos
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox(
            child: Center(
              child: Text(
                'Pagina de eventos',
              ),
            ),
          ),
        ),

        /// Area de QRcode
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      //Navega para a tela de leitura de QR code
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BarcodeScannerSimple()),
                      );
                    },
                    child: const Text('Abrir Leitor de QR Code')),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    //Navega para a tela de leitura de QR code
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GenerateQRCode()),
                    );
                  },
                  child: const Text('Mostrar QR code')),
            ],
          ),
        ),

        /// Area do perfil
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            child: Center(
              child: Text(
                'Area do perfil',
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}
