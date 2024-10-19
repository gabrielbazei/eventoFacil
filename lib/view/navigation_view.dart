import 'package:eventofacil/model/event_model.dart';
import 'package:eventofacil/presenter/navigation_presenter.dart';
import 'package:eventofacil/view/gerador_view.dart';
import 'package:eventofacil/view/leitor_view.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<Dashboard>
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
      bottomNavigationBar: Stack(
        children: [
          NavigationBar(
            onDestinationSelected: (int index) {
              _presenter.onPageSelected(index);
            },
            indicatorColor: Colors.transparent, // Torna o indicador invisível
            selectedIndex: _presenter.currentPageIndex,
            backgroundColor: Colors.blue, // Cor de fundo da NavigationBar
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.list_outlined, color: Colors.white),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.wallet, color: Colors.white),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.white),
                label: '',
              ),
            ],
          ),
          Positioned(
            left: _presenter.currentPageIndex *
                (MediaQuery.of(context).size.width / 3), // Ajusta a posição
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 4, // Altura do sublinhado
              color: Colors.white, // Cor do sublinhado
            ),
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _presenter.onCreateEvent(context);
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView(
                      children: _buildEventItems(events.cast<Event>()),
                    ),
                  ),
                ],
              ),
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
                    event.nomeEvento,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(
                            255, 61, 61, 61) // Cor do texto para ciza
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    event.descricao,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 61, 61, 61)),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data: ${event.dataInicio.toIso8601String()}', // Exibe a data
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 61, 61, 61)),
                      ),
                      if (event.isAdmin && event.isSubscribed) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BarcodeScannerSimple(),
                              ),
                            );
                          },
                          child: const Text(
                            'Abrir Leitor de QR Code',
                            style:
                                TextStyle(color: Colors.blue), // Botão em azul
                          ),
                        ),
                      ],
                      if (!event.isSubscribed) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _presenter.onJoinEvent(event);
                                // Exibe o dialog de confirmação
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Presença Confirmada'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Fecha o diálogo
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Participar',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  //const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildWallet() {
    final events = _presenter.getSubscribedEvents();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
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
                          event.nomeEvento,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.descricao,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Campo de data alinhado verticalmente
                            Text(
                              'Data: ${event.dataInicio.toIso8601String()}', // Exibe a data
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 61, 61, 61),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Mostra o alerta de confirmação
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Garante que a coluna não ocupe muito espaço
                                            children: [
                                              const Text(
                                                "Tem certeza que deseja cancelar a inscrição neste evento?",
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ), // Espaço entre o título e os botões

                                              TextButton(
                                                child: const Text(
                                                  'Cancelar Ingresso',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  _presenter.onCancelEvent(
                                                      event); // Chama o método de cancelamento
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o diálogo
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'Voltar',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o diálogo
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors
                                        .red, // Cor do texto para o botão de cancelar
                                  ),
                                  child: const Text('Cancelar Ingresso'),
                                ),
                                const SizedBox(
                                    width: 8), // Espaço entre os botões
                                TextButton(
                                  onPressed: () {
                                    // Lógica para visualizar o QR Code do ingresso
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const GenerateQRCode(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors
                                        .blue, // Cor do texto para o botão de visualizar ingresso
                                  ),
                                  child: const Text('Visualizar Ingresso'),
                                ),
                              ],
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
    final formKey = GlobalKey<FormState>();
    String? phone;
    String? address;
    String? number;
    String? city;
    String? birthDate;
    String? selectedGender;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Telefone',
                filled: true,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                phone = value;
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
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onSaved: (value) {
                      address = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      number = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cidade',
                filled: true,
                border: InputBorder.none,
              ),
              onSaved: (value) {
                city = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                filled: true,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.datetime,
              onSaved: (value) {
                birthDate = value;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gênero',
                filled: true,
                border: InputBorder.none,
              ),
              value: selectedGender,
              items: const [
                DropdownMenuItem(value: 'F', child: Text('Feminino')),
                DropdownMenuItem(value: 'M', child: Text('Masculino')),
              ],
              onChanged: (value) {
                selectedGender = value;
              },
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20), // Margem de 20
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState?.save();
                        _presenter.onSave(phone, address, number, city,
                            birthDate, selectedGender);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.black), // Borda preta
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Formato quadrado
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.blue), // Texto azul
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5), // Margem de 20
                  child: ElevatedButton(
                    onPressed: () {
                      _presenter.onLogout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.black), // Borda preta
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Formato quadrado
                      ),
                    ),
                    child: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.red), // Texto vermelho
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _presenter.onPasswordChage();
                  },
                  child: const Text(
                    'Alterar Senha',
                    style: TextStyle(color: Colors.blue), // Texto azul
                  ),
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
