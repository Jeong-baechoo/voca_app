import 'package:flutter/material.dart';
import 'package:voca_app/models/word_description.dart';

class WordDescriptionProvider with ChangeNotifier {
  WordDescription? _wordDescription;

  WordDescription? get wordDescription => _wordDescription;
  void setWordDescription(WordDescription newWordDescription) {
    _wordDescription = newWordDescription;
    notifyListeners();
  }

  void initWordDescription() {
    _wordDescription = null;
    notifyListeners();
  }
}
