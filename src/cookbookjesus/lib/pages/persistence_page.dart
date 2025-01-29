import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class PersistencePage extends StatelessWidget {
  const PersistencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Persistencia de Datos',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7), // Lavanda pastel
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF), // Blanco rosado muy suave
              Color(0xFFF5F0FF), // Lavanda muy claro
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPersistenceCard(
              context,
              'Archivos',
              'Lectura y escritura de archivos',
              const FileStorageDemo(),
            ),
            _buildPersistenceCard(
              context,
              'Preferencias',
              'Almacenamiento de datos clave-valor',
              const SharedPreferencesDemo(),
            ),
            _buildPersistenceCard(
              context,
              'SQLite',
              'Base de datos local SQLite',
              const SQLiteDemo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistenceCard(
      BuildContext context,
      String title,
      String description,
      Widget page,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFE0B2), // Melocotón pastel
              Color(0xFFC8E6C9), // Verde menta pastel
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A5568),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF4A5568),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
        ),
      ),
    );
  }
}

// Demo de almacenamiento de archivos
class FileStorageDemo extends StatefulWidget {
  const FileStorageDemo({super.key});

  @override
  State<FileStorageDemo> createState() => _FileStorageDemoState();
}

class _FileStorageDemoState extends State<FileStorageDemo> {
  final TextEditingController _controller = TextEditingController();
  String _content = '';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/demo.txt');
  }

  Future<void> _writeContent() async {
    final file = await _localFile;
    await file.writeAsString(_controller.text);
    _readContent();
  }

  Future<void> _readContent() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      setState(() {
        _content = contents;
      });
    } catch (e) {
      setState(() {
        _content = 'Error al leer el archivo: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _readContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Almacenamiento de Archivos',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Escribe algo para guardar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3E5FC),
                foregroundColor: const Color(0xFF4A5568),
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _writeContent,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contenido del archivo:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Text(_content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Demo de SharedPreferences
class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({super.key});

  @override
  State<SharedPreferencesDemo> createState() => _SharedPreferencesDemoState();
}

class _SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final TextEditingController _controller = TextEditingController();
  String _savedValue = '';

  Future<void> _saveValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('demo_key', _controller.text);
    _loadValue();
  }

  Future<void> _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedValue = prefs.getString('demo_key') ?? 'No hay valor guardado';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SharedPreferences Demo',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Valor a guardar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3E5FC),
                foregroundColor: const Color(0xFF4A5568),
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _saveValue,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Valor guardado:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Text(_savedValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Demo de SQLite
class SQLiteDemo extends StatefulWidget {
  const SQLiteDemo({super.key});

  @override
  State<SQLiteDemo> createState() => _SQLiteDemoState();
}

class _SQLiteDemoState extends State<SQLiteDemo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _addNote() async {
    final db = await _getDatabase();
    await db.insert(
      'notes',
      {
        'title': _titleController.text,
        'description': _descriptionController.text,
      },
    );
    _loadNotes();
    _titleController.clear();
    _descriptionController.clear();
  }

  Future<void> _loadNotes() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    setState(() {
      _notes = maps;
    });
  }

  Future<void> _deleteNote(int id) async {
    final db = await _getDatabase();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadNotes();
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SQLite Demo',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB3E5FC),
                      foregroundColor: const Color(0xFF4A5568),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _addNote,
                    child: const Text('Agregar Nota'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(_notes[index]['title']),
                      subtitle: Text(_notes[index]['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteNote(_notes[index]['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
