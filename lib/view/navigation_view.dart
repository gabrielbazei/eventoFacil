import 'package:eventofacil/model/navigation_model.dart';
import 'package:eventofacil/presenter/navigation_presenter.dart';
import 'package:eventofacil/view/gerador_view.dart';
import 'package:eventofacil/view/leitor_view.dart';
import 'package:flutter/material.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample>
    implements NavigationView {
  late NavigationPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = NavigationPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          _presenter.onPageSelected(index);
        },
        indicatorColor: Colors.amber,
        selectedIndex: _presenter.currentPageIndex,
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
      body: _getSelectedPage(),
    );
  }

  Widget _getSelectedPage() {
    switch (_presenter.currentPageIndex) {
      case 0:
        return _buildEventPage();
      case 1:
        return _buildQrCodePage();
      case 2:
        return _buildProfilePage();
      default:
        return const Center(child: Text('Página não encontrada!'));
    }
  }

  Widget _buildEventPage() {
    final events = _presenter.getEvents();
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Center(
          child: Column(
            children: [
              const Text(
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                'Área de eventos',
              ),
              const SizedBox(height: 20), // Espaçamento entre o título e o menu
              ..._buildEventItems(events.cast<Event>()),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEventItems(List<Event> events) {
    return events.map((event) {
      return Container(
        width: double.infinity, // Largura responsiva
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            _presenter.onEventSelected(event.title);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildQrCodePage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BarcodeScannerSimple()),
                );
              },
              child: const Text('Abrir Leitor de QR Code'),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerateQRCode()),
              );
            },
            child: const Text('Mostrar QR code'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        child: Center(
          child: Text('Área do perfil'),
        ),
      ),
    );
  }

  @override
  void updateView(int index) {
    setState(() {});
  }
}
