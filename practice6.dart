import 'dart:async';
import 'package:flutter/material.dart';
import 'database_helperscore.dart';
import 'score.dart';

class Practice6 extends StatefulWidget {
  @override
  _Practice6State createState() => _Practice6State();
}

class _Practice6State extends State<Practice6> {
  int _puntos = 0;
  bool _juegoEnCurso = false;
  Timer? _timer;
  int _tiempoRestante = 10;
  TextEditingController _nombreController = TextEditingController();
  List<Score> _scores = [];
  bool _nombreIngresado = false;

  @override
  void initState() {
    super.initState();
    _cargarScores();
  }

  void _cargarScores() async {
    _scores = await DatabaseHelper.instance.getScores();
    setState(() {});
  }

  void _iniciarJuego() {
    setState(() {
      _puntos = 0;
      _juegoEnCurso = true;
      _tiempoRestante = 10;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _tiempoRestante--;
        if (_tiempoRestante == 0) {
          _terminarJuego();
          timer.cancel();
        }
      });
    });
  }

  void _terminarJuego() {
    setState(() {
      _juegoEnCurso = false;
    });
    _mostrarDialogoGuardarScore();
  }

  void _mostrarDialogoGuardarScore() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[100],
          title: Text('Guardar Puntaje', style: TextStyle(color: const Color.fromARGB(255, 197, 104, 255))),
          content: Text('¿Guardar puntaje?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _guardarScore();
              },
              child: Text('Guardar', style: TextStyle(color: const Color.fromARGB(255, 196, 100, 255))),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            )
          ],
        );
      },
    );
  }

  void _guardarScore() async {
    final score = Score(nombre: _nombreController.text, puntos: _puntos);
    await DatabaseHelper.instance.insertScore(score);
    _nombreController.clear();
    _cargarScores();
  }

  void _eliminarHistorial() async {
    await DatabaseHelper.instance.limpiarHistorial();
    _cargarScores();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Juego'),
        backgroundColor: const Color.fromARGB(255, 225, 92, 248),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!_nombreIngresado)
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Ingresa tu nombre'),
                  onSubmitted: (value) {
                    setState(() {
                      _nombreIngresado = true;
                    });
                  },
                ),
              if (_nombreIngresado) ...[
                Text('Puntos: $_puntos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple)),
                SizedBox(height: 10),
                Text('Tiempo: $_tiempoRestante', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _juegoEnCurso ? () => setState(() => _puntos++) : _iniciarJuego,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    backgroundColor: _juegoEnCurso ? Colors.purple[200] : const Color.fromARGB(255, 229, 81, 255),
                    elevation: 0,
                  ),
                  child: Text(_juegoEnCurso ? 'Contar' : '¡Iniciar juego!'),
                ),
                SizedBox(height: 30),
                Text('Puntajes:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _scores.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_scores[index].nombre, style: TextStyle(color: const Color.fromARGB(255, 182, 86, 241))),
                        trailing: Text('${_scores[index].puntos}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _eliminarHistorial,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Eliminar Historial'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}