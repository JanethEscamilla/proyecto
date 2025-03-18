import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';





class Practice4 extends StatefulWidget {
  @override
  _Practice4State createState() => _Practice4State();
}

class _Practice4State extends State<Practice4> {
  int _score = 0;
  bool _isPlaying = false;
  late DateTime startTime;
  int _timeLeft = 10;
  Timer? _timer;

  void _startGame() {
    setState(() {
      _score = 0;
      _isPlaying = true;
      startTime = DateTime.now();
      _timeLeft = 10;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _isPlaying = false;
          _timer?.cancel();
          _saveScore(_score);
        }
      });
    });
  }

  void _incrementScore() {
    if (_isPlaying) {
      setState(() {
        _score++;
      });
    }
  }

  Future<File> get _file async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/scores.txt');
  }

  Future<void> _saveScore(int score) async {
    final file = await _file;
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('$timestamp: $score\n', mode: FileMode.append);
  }

  Future<List<String>> _loadScores() async {
    try {
      final file = await _file;
      return await file.readAsLines();
    } catch (e) {
      return [];
    }
  }

  void _showScores() async {
    List<String> scores = await _loadScores();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Historial:"),
          content: SingleChildScrollView(
            child: ListBody(
              children: scores.map((s) => Text(s)).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Juego de Contar"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Puntuación: $_score", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Tiempo restante: $_timeLeft s", style: TextStyle(fontSize: 22, color: const Color.fromARGB(255, 165, 56, 255))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              _isPlaying
                  ? ElevatedButton(
                      onPressed: _incrementScore,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: const Color.fromARGB(255, 187, 158, 255), // Corregido a backgroundColor
                      ),
                      child: Text("Tocar"),
                    )
                  : ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: const Color.fromARGB(255, 217, 110, 250), // Corregido a backgroundColor
                      ),
                      child: Text("Iniciar Juego"),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showScores,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color.fromARGB(255, 217, 110, 250), // Corregido a backgroundColor
                ),
                child: Text("Ver Historial"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}