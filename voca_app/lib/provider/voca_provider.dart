import 'package:flutter/material.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/model/wordDescription.dart';

class VocaProvider with ChangeNotifier {
  int _selectedVocaSet = 0;

  int get selectedVocaSet => _selectedVocaSet;

  selectVocaSet(int newValue) {
    _selectedVocaSet = newValue;
    notifyListeners();
  }

  void addWord(WordDescription word) {
    Map<String, dynamic> newWord = word.toJson();
    myVocaSet[_selectedVocaSet].add(newWord);
    notifyListeners();
  }

  void deleteWord(int index) {
    // Remove the word from the selected vocabulary set
    myVocaSet[_selectedVocaSet].removeAt(index);
    notifyListeners();
  }
}
