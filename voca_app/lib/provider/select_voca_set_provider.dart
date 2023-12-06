import 'package:flutter/material.dart';

class VocaSetProvider with ChangeNotifier {
  int _selectedVocaSet = 0;

  int get selectedVocaSet => _selectedVocaSet;

  selectVocaSet(int newValue) {
    _selectedVocaSet = newValue;
    notifyListeners();
  }
}
