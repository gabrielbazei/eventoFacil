import 'package:eventofacil/model/event_model.dart';
import 'package:eventofacil/model/usuario_model.dart';
import 'package:eventofacil/presenter/navigation_presenter.dart';
import 'package:eventofacil/view/gerador_view.dart';
import 'package:eventofacil/view/leitor_view.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String login;
  const Dashboard(this.login, {super.key});

  @override
  State<Dashboard> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<Dashboard>
    implements NavigationView {
  late NavigationPresenter _presenter;
  late String _login;

  @override
  void initState() {
    super.initState();
    _login = widget.login;
    _presenter = NavigationPresenter(this);
    _presenter.load(_login);
    updateView(0);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _presenter.load(_login),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            bottomNavigationBar: Stack(
              children: [
                NavigationBar(
                  onDestinationSelected: (int index) {
                    _presenter.onPageSelected(index);
                  },
                  indicatorColor:
                      Colors.transparent, // Torna o indicador invisível
                  selectedIndex: _presenter.currentPageIndex,
                  backgroundColor: const Color.fromRGBO(73, 149, 180,
                      1), // Cor de fundo da NavigationBar rgba(73,149,180,255)
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
                      (MediaQuery.of(context).size.width /
                          3), // Ajusta a posição
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
      },
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
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Center(
          child: Stack(
            children: [
              FutureBuilder<bool>(
                future: _presenter.isOrganizador(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error: ${snapshot.error}')); // Show error message
                  } else {
                    bool isOrganizador = snapshot.data ?? false;
                    return isOrganizador
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  right: 8.0), // Adjust the padding as needed
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(73, 149, 180, 1),
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
                          )
                        : Container(); // Return an empty container if not an organizer
                  }
                },
              ),
              Column(
                children: [
                  const SizedBox(height: 40),
                  Expanded(
                    child: FutureBuilder<List<Event>>(
                      future: _presenter.getEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('Nenhum evento encontrado.'));
                        } else {
                          return ListView(
                            children:
                                _buildEventItems(snapshot.data!.cast<Event>()),
                          );
                        }
                      },
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
                        'Data: ${_presenter.formataData(event.dataInicio)}', // Exibe a data
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 61, 61, 61)),
                      ),
                      if (_presenter.checkAdmin(event.id)) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BarcodeScannerSimple(
                                  cpf: widget.login,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Abrir Leitor de QR Code',
                            style: TextStyle(
                              color: Color.fromRGBO(
                                  73, 149, 180, 1), // Botão em azul
                            ),
                          ),
                        ),
                      ],
                      if (!_presenter.checkExist(event.id)) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _presenter.onJoinEvent(event, context);
                                // Exibe o dialog de confirmação
                              },
                              child: const Text(
                                'Participar',
                                style: TextStyle(
                                    color: Color.fromRGBO(73, 149, 180, 1)),
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
    final userEvents = _presenter.getSubscribedEvents();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: userEvents.length,
              itemBuilder: (context, index) {
                final userEvent = userEvents[index];
                final Event event = _presenter.getEvent(userEvent.idEvento);
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
                              'Data: ${_presenter.formataData(event.dataInicio)}', // Exibe a data,
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
                                                      userEvent,
                                                      context); // Chama o método de cancelamento
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o diálogo
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'Voltar',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          73, 149, 180, 1)),
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
                                            GenerateQRCode(userEvent.hashQR),
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
    Usuario user = _presenter.getUsuario();

    // Controladores para os campos de texto
    final TextEditingController nomeController =
        TextEditingController(text: user.nome);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController phoneController =
        TextEditingController(text: user.telefone);
    final TextEditingController addressController =
        TextEditingController(text: user.endereco);
    final TextEditingController numberController =
        TextEditingController(text: user.numEndereco);
    final TextEditingController cityController =
        TextEditingController(text: user.cidade);
    final TextEditingController birthDateController = TextEditingController(
        text: user.dataNascimento != null
            ? '${user.dataNascimento!.toLocal()}'.split(' ')[0]
            : '');

    String? selectedGender = user.genero;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'nome',
                filled: true,
                border: InputBorder.none,
              ),
              onSaved: (value) {
                nomeController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'email',
                filled: true,
                border: InputBorder.none,
              ),
              onSaved: (value) {
                emailController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                filled: true,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                phoneController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onSaved: (value) {
                      addressController.text = value ?? '';
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      numberController.text = value ?? '';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                filled: true,
                border: InputBorder.none,
              ),
              onSaved: (value) {
                cityController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: birthDateController,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                filled: true,
                border: InputBorder.none,
              ),
              readOnly: true, // Para evitar que o usuário digite manualmente
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: user.dataNascimento ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  birthDateController.text =
                      '${pickedDate.toLocal()}'.split(' ')[0];
                }
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
                        _presenter.onSave(
                          context,
                          nomeController.text,
                          emailController.text,
                          phoneController.text,
                          addressController.text,
                          numberController.text,
                          cityController.text,
                          DateTime.tryParse(birthDateController
                              .text), // Converter texto para DateTime
                          selectedGender,
                        );
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
                      style: TextStyle(
                          color: Color.fromRGBO(73, 149, 180, 1)), // Texto azul
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
                    _presenter.onPasswordChage(context);
                  },
                  child: const Text(
                    'Alterar Senha',
                    style: TextStyle(
                        color: Color.fromRGBO(73, 149, 180, 1)), // Texto azul
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
