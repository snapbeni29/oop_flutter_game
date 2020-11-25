import 'package:corona_bot/constants.dart';

class LevelModel {
  double _score = 0.0;
  Stopwatch _timer = new Stopwatch();

  LevelModel() {
    resetTimer();
    startTimer();
  }

  void startTimer() {
    _timer.start();
  }

  void resetTimer() {
    _timer.reset();
  }

  void stopTimer() {
    _timer.stop();
  }

  void winPoints(double points) {
    _score += points;
  }

  void usePoints(double points) {
    _score -= points;
  }

  double get timeLeft => TIME_LEVEL - _timer.elapsedMilliseconds / 1000;

  double get score => _score;

  String get time => timeLeft.toStringAsFixed(0);

  bool get timeOver => timeLeft <= 0.5;
}
