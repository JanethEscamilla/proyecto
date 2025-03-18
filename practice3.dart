import 'dart:async';
import 'package:flutter/material.dart';


class Practice3 extends StatefulWidget {
  @override
  _Practice3State createState() => _Practice3State();
}

class _Practice3State extends State<Practice3> {
  int _counter = 0;
  bool _isTimerRunning = false;
  Timer? _timer;
  int _timeLeft = 10;

  void _startTimer() {
    if (_isTimerRunning) return; // Evita iniciar múltiples temporizadores

    setState(() {
      _isTimerRunning = true;
      _timeLeft = 10;
      _counter = 0; // Reiniciar contador cuando inicia el temporizador
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          _isTimerRunning = false; // Detener el contador cuando el tiempo acabe
          _showResult();
        }
      });
    });
  }

  void _incrementCounter() {
    if (!_isTimerRunning) {
      _startTimer();
    }
    if (_isTimerRunning) {
      setState(() {
        _counter++;
      });
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tiempo finalizado'),
        content: Text('Total de clicks: $_counter'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetState();
            },
            child: Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _resetState() {
    setState(() {
      _counter = 0;
      _isTimerRunning = false;
      _timeLeft = 10;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Práctica 3 - Contador con Temporizador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Presiona el botón antes de que pasen 10 segundos:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Tiempo restante: $_timeLeft s',
              style: TextStyle(fontSize: 16, color: Colors.red),
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
