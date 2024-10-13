import 'package:eventofacil/deprecated/event.dart';
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
        return _buildWallet();
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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            _presenter.onEventSelected(context, event);
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
                  const SizedBox(height: 8.0),
                  // Verifica se o usuário é admin para exibir os botões apropriados
                  if (event.isAdmin) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /*TextButton(
                          onPressed: () {
                            _presenter.onEditEvent(context, event);
                          },
                          child: const Text('Editar'),
                        ),*/
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BarcodeScannerSimple()),
                            );
                          },
                          child: const Text('Abrir Leitor de QR Code'),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _presenter.onJoinEvent(event);
                          },
                          child: const Text('Participar'),
                        ),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildWallet() {
    final events = _presenter
        .getSubscribedEvents(); // Supondo que há um método que retorna os eventos em que o usuário está inscrito.

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Eventos Inscritos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _presenter.onCancelEvent(event);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .red, // Cor diferenciada para o botão de cancelamento
                              ),
                              child: const Text('Cancelar Ingresso'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Lógica para visualizar o QR Code do ingresso
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenerateQRCode(),
                                  ),
                                );
                              },
                              child: const Text('Visualizar Ingresso'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    final _formKey = GlobalKey<FormState>();
    String? _phone;
    String? _address;
    String? _number;
    String? _city;
    String? _birthDate;
    String? _selectedGender;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                _phone = value;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _address = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _number = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cidade',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                _city = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              onSaved: (value) {
                _birthDate = value;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(),
              ),
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'F', child: Text('Feminino')),
                DropdownMenuItem(value: 'M', child: Text('Masculino')),
              ],
              onChanged: (value) {
                _selectedGender = value;
              },
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      // Salvar as informações aqui
                      print(
                          'Salvando informações: Telefone: $_phone, Endereço: $_address, Número: $_number, Cidade: $_city, Data de Nascimento: $_birthDate, Gênero: $_selectedGender');
                    }
                  },
                  child: const Text('Salvar'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para sair do perfil
                    print('Saindo...');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Cor para diferenciar o botão de sair
                  ),
                  child: const Text('Sair'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Lógica para alterar a senha
                    print('Alterar Senha');
                  },
                  child: const Text('Alterar Senha'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void updateView(int index) {
    setState(() {});
  }
}
