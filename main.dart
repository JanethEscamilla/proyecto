import 'package:flutter/material.dart';
import 'practice1.dart';
import 'practice2.dart';
import 'practice3.dart';
import 'practice4.dart';
import 'practice5.dart';
import 'practice6.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prácticas Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 columnas
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildMenuItem(context, 'Práctica 1', 'Hola Mundo', Practice1()),
            _buildMenuItem(context, 'Práctica 2', 'Contador de Clicks', Practice2()),
            _buildMenuItem(context, 'Práctica 3', 'Contador con Temporizador', Practice3()),
            _buildMenuItem(context, 'Práctica 4', 'Historial en Archivo', Practice4()),
            _buildMenuItem(context, 'Práctica 5', 'Almacenamiento SQLite', Practice5()),
            _buildMenuItem(context, 'Práctica 6', 'Historial en SQLite', Practice6()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String subtitle, Widget page) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}