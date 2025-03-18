import 'package:flutter/material.dart';

class Practice2 extends StatefulWidget {
  @override
  _Practice2State createState() => _Practice2State();
}

class _Practice2State extends State<Practice2> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Práctica 2 - Contador de Clicks')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Has presionado el botón:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_counter veces',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Incrementar'),
            ),
          ],
        ),
      ),
    );
  }
}
