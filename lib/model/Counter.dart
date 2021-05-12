import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  int value = 0;

  int get getCounter {
    return value;
  }

  void incrementCounter() {
    value += 1;
    notifyListeners();
  }
}