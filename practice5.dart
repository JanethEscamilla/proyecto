import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Practice5 extends StatefulWidget {
  @override
  _Practice5State createState() => _Practice5State();
}

class _Practice5State extends State<Practice5> {
  late Database _database;
  List<Map<String, dynamic>> _people = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'people_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE people(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
    _loadPeople();
  }

  Future<void> _loadPeople() async {
    final List<Map<String, dynamic>> people = await _database.query('people');
    setState(() {
      _people = people;
    });
  }

  Future<void> _addPerson(String name, int age) async {
    await _database.insert(
      'people',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadPeople();
  }

  Future<void> _deletePerson(int id) async {
    await _database.delete('people', where: 'id = ?', whereArgs: [id]);
    _loadPeople();
  }

  void _showAddPersonDialog(BuildContext context) { // Añadido BuildContext context
    String name = '';
    String age = '';

    showDialog(
      context: context, // Usando el context pasado como argumento
      builder: (context) => AlertDialog(
        title: Text('Agregar Persona'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nombre'),
              onChanged: (value) => name = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
              onChanged: (value) => age = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (name.isNotEmpty && age.isNotEmpty) {
                _addPerson(name, int.parse(age));
              }
              Navigator.pop(context);
            },
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Práctica 5 - SQLite')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _people.length,
              itemBuilder: (context, index) {
                final person = _people[index];
                return ListTile(
                  title: Text('${person['name']}'),
                  subtitle: Text('Edad: ${person['age']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePerson(person['id']),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _showAddPersonDialog(context), // Pasando context
            child: Text('Agregar Persona'),
          ),
        ],
      ),
    );
  }
}