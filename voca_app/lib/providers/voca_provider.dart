import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VocaProvider with ChangeNotifier {
  int _selectedVocaSet = 0;
  final List<String> _vocabularySets = ['내 단어장']; // 단어장 이름들

  List<String> get vocabularySets => _vocabularySets;
  int get selectedVocaSet => _selectedVocaSet;

  final db = FirebaseFirestore.instance;
  final userId = '9Z3gdqPhTd37B6xVpf0H';

  // 앱 시작시 Firestore에서 단어장 리스트를 가져와 업데이트
  Future<void> fetchAndSetVocabularySets() async {
    try {
      final wordListsSnapshot = db
          .collection('users')
          .doc(userId) //user_id
          .collection('wordLists');
      _vocabularySets.clear();
      // Firestore에서 가져온 데이터를 리스트에 추가
      await wordListsSnapshot.where("listName").get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            _vocabularySets.add(docSnapshot.data()['listName']); // 단어장 목록 업데이트
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    } catch (error) {
      print('Error fetching vocabulary sets: $error');
    }
    notifyListeners();
  }

  // 선택된 단어장의 인덱스
  void selectVocaSet(int newValue) {
    _selectedVocaSet = newValue;

    notifyListeners();
  }

  Future<void> addVocabularySet(String newVocaSet) async {
    _vocabularySets.add(newVocaSet);

    // Firestore에 새로운 단어장 추가=
    await db
        .collection('users')
        .doc(userId)
        .collection('wordLists')
        .add({'listName': newVocaSet});

    notifyListeners();
  }

  Future<void> updateVocabularySet(int index, String newVocaSet) async {
    // Firestore에서 해당 단어장 업데이트
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('wordLists')
        .where('listName', isEqualTo: _vocabularySets[index])
        .get();

    for (var doc in querySnapshot.docs) {
      print(doc.data());
      doc.reference.update({
        'listName': newVocaSet,
        // 다른 필드가 있다면 여기에 추가
      });
    }
    _vocabularySets[index] = newVocaSet;
    notifyListeners();
  }

  Future<void> deleteVocabularySet(List<dynamic> myVocaSet, int index) async {
    print(_vocabularySets[index]);
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('wordLists')
        .where('listName', isEqualTo: _vocabularySets[index])
        .get();

    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
    myVocaSet.removeAt(index);
    _vocabularySets.removeAt(index);
    notifyListeners();
  }
}
