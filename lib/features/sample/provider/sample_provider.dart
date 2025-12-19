import 'package:flutter/foundation.dart';

class SampleProvider extends ChangeNotifier {
  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }
}


