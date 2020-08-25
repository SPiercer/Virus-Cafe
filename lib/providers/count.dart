import 'package:flutter/material.dart';

class CountProvider extends ChangeNotifier {
  final Map<String, double> _counts = {};

  Map<String, double> get count => _counts;

  void increment(String key, double count) {
    if (_counts.containsKey(key)) {
      _counts.update(key, (value) => value + count);
    } else {
      _counts[key] = count;
    }
    print(_counts);
    notifyListeners();
  }
}
