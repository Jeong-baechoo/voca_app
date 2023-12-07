import 'package:flutter/material.dart';

//단어장 관리 프로바이더
class VocaProvider with ChangeNotifier {
  int _selectedVocaSet = 0;
  final List<String> _vocabularySets = ['내 단어장', 'Item : 1'];

  List<String> get vocabularySets => _vocabularySets;
  int get selectedVocaSet => _selectedVocaSet;

  void selectVocaSet(int newValue) {
    _selectedVocaSet = newValue;
    notifyListeners();
  }

  void addVocabularySet(String newVocaSet) {
    _vocabularySets.add(newVocaSet);
    notifyListeners();
  }

  void updateVocabularySet(int index, String newVocaSet) {
    _vocabularySets[index] = newVocaSet;
    notifyListeners();
  }

  void deleteVocabularySet(int index) {
    _vocabularySets.removeAt(index);
    notifyListeners();
  }
}
