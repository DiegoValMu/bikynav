import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchProvider with ChangeNotifier {
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _totalTimeStopped = 0;  // Guardará el tiempo total cuando se detenga el cronómetro

  int get elapsedSeconds => _elapsedSeconds;
  int get totalTimeStopped => _totalTimeStopped;  // Getter para acceder al tiempo total detenido

  // Iniciar el cronómetro
  void startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedSeconds++;
        notifyListeners();  // Notifica a los widgets suscritos
      });
    }
  }

  // Detener el cronómetro
  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _totalTimeStopped = _elapsedSeconds;  // Guardar el tiempo acumulado hasta detenerlo
      _timer = null;
      notifyListeners();  // Notifica a los widgets suscritos
    }
  }

  // Reiniciar el cronómetro
  void resetTimer() {
    _elapsedSeconds = 0;
    _totalTimeStopped = 0;  // Reiniciar el tiempo acumulado al resetear el cronómetro
    notifyListeners();  // Notifica a los widgets suscritos
  }
}
