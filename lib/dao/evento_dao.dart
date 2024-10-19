import 'package:eventofacil/model/event_model.dart';
import 'package:eventofacil/presenter/navigation_presenter.dart';

class EventoDao {
  /*static final EventoDao instance = EventoDao._init();

  static Database? _database;

  EventoDao._init();

  Future<Database> get Database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('evento.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE evento(
      idEvento INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeEvento TEXT NOT NULL,
      descricao TEXT NOT NULL,
      dataInicio TEXT NOT NULL,
      dataFim TEXT,
      local TEXT NOT NULL
    )
    ''');
  }

  Future<void> inserirEvento(Event evento) async {
    final db = await instance.Database;
    await db.insert(
      'evento',
      evento.toMap(), // Convertendo o objeto Evento para um mapa
      conflictAlgorithm: ConflictAlgorithm.replace, // Para lidar com conflitos
    );
  }

  Future<List<Event>> obterEventos() async {
    final db = await instance.Database;
    final List<Map<String, dynamic>> maps = await db.query('evento');

    return List.generate(maps.length, (i) {
      return Event(
        idEvento: maps[i]['idEvento'],
        nomeEvento: maps[i]['nomeEvento'],
        descricao: maps[i]['descricao'],
        dataInicio: maps[i]['dataInicio'],
        dataFim: maps[i]['dataFim'],
        local: maps[i]['local'],
      );
    });
  }

  Future<void> atualizarEvento(Event evento) async {
    final db = await instance.Database;
    await db.update(
      'evento',
      evento.toMap(),
      where: 'idEvento = ?',
      whereArgs: [evento.id],
    );
  }

  Future<void> deletarEvento(int idEvento) async {
    final db = await instance.Database;
    await db.delete(
      'evento',
      where: 'idEvento = ?',
      whereArgs: [idEvento],
    );
  }*/
}
