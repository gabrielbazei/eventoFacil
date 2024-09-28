/*import 'package:eventofacil/gerar.dart';
import 'package:eventofacil/leitor.dart';
import 'package:flutter/material.dart';

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
            icon: Icon(Icons.wallet),
            label: 'Carteira',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Meu perfil',
          ),
        ],
      ),
      body: <Widget>[
        /// Area de eventos
        Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox(
            child: Center(
              child: Column(
                children: [
                  Text(
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      'Area de eventos'),
                  SizedBox(height: 20), // Espaçamento entre o título e o menu
                  ..._buildEventItems(),
                ],
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

List<Widget> _buildEventItems() {
  // Exemplo de eventos
  final events = [
    {'title': 'Evento 1', 'description': 'Descrição do Evento 1'},
    {'title': 'Evento 2', 'description': 'Descrição do Evento 2'},
    {'title': 'Evento 3', 'description': 'Descrição do Evento 3'},
  ];

  return events.map((event) {
    return Container(
      width: double.infinity, // Largura responsiva
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Ação ao clicar no evento
          print('${event['title']} clicado!');
          // Você pode adicionar navegação ou outras ações aqui
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  event['description']!,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }).toList();
}*/
