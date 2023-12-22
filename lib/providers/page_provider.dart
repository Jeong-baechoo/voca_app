import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  selectPage(int newValue) {
    _selectedPage = newValue;
    notifyListeners();
  }
}
