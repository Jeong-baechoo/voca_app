
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voca_app/models/word_description.dart';

//단어들 관리 프로바이더
class WordProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<List<Map<String, dynamic>>> myWordSets = [
  ];

  //추천 단어장
  List<List<Map<String, dynamic>>> recommendWordSets = [];


  //로그인 기능을 구현할 필요가 있으면 유저ID를 가져 올 예정
  final userId = '9Z3gdqPhTd37B6xVpf0H';
  Future<void> initializeWords() async {

    try {
      // Firestore에서 모든 단어장 가져오기
      myWordSets.clear();
      QuerySnapshot wordListsSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('wordLists')
          .get();
      // 가져온 각 단어장에 대해 단어를 초기화하고 리스트에 추가
      for (var wordListDoc in wordListsSnapshot.docs) {
        String wordListId = wordListDoc.id;

        // 단어를 가져오는 쿼리 실행
        QuerySnapshot wordSnapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('wordLists')
            .doc(wordListId)
            .collection('words')
            .get();

        // 가져온 데이터를 로컬 상태에 추가
        myWordSets.add(wordSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>?)
            .where((data) => data != null)
            .cast<Map<String, dynamic>>()
            .toList());
      }
    } catch (e) {
      myWordSets = [
        //현재 단어장
        [wordData]
      ];
      print('단어 초기화 오류: $e');
    }

    var querySnapshot = await firestore.collection("recommendWordLists").get();

    for(var wordListDoc in querySnapshot.docs){
      var querySnapshot2 = await firestore.collection("recommendWordLists").doc(wordListDoc.id).collection('words').get();
      recommendWordSets.add(querySnapshot2.docs.map((doc) => doc.data()).cast<Map<String,dynamic>>().toList());
    }
  }

  Future<void> addWord(int selectedVocaSet, String selectedVocaSetName,
      WordDescription word) async {
    Map<String, dynamic> newWord = word.toJson();
    try {
      // Firestore에서 모든 단어장 가져오기
      QuerySnapshot wordListsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wordLists')
          .get();

      // 선택된 단어장 이름과 일치하는 단어장 찾기
      DocumentSnapshot selectedWordList = wordListsSnapshot.docs.firstWhere(
        (doc) => (doc.data() as Map)['listName'] == selectedVocaSetName,
        orElse: () => throw Exception('Selected word list not found'),
      );

      // 선택된 단어장에 단어 추가
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wordLists')
          .doc(selectedWordList.id) // 선택된 단어장의 문서 ID
          .collection('words')
          .add(newWord);

      myWordSets[selectedVocaSet].add(newWord);
      print('단어 추가 성공');
    } catch (e) {
      print('단어 추가 오류: $e');
    }
    notifyListeners();
  }

  Future<void> deleteWord(
      String currentVocaSet, int selectedVocaSet, int index) async {
    Map<String, dynamic> deletedWord = myWordSets[selectedVocaSet][index];

    try {
      CollectionReference<Map<String, dynamic>> wordListsCollection =
          firestore.collection('users').doc(userId).collection('wordLists');

      // Find the wordListId based on the listName
      QuerySnapshot<Map<String, dynamic>> wordListQuery =
          await wordListsCollection
              .where('listName', isEqualTo: currentVocaSet)
              .get();

      if (wordListQuery.docs.isNotEmpty) {
        String wordListId = wordListQuery.docs.first.id;

        // Use the wordListId to delete the word from the 'words' collection
        CollectionReference<Map<String, dynamic>> wordsCollection =
            wordListsCollection.doc(wordListId).collection('words');
        QuerySnapshot<Map<String, dynamic>> wordQuery = await wordsCollection
            .where('word', isEqualTo: deletedWord['word'])
            .get();

        wordQuery.docs.forEach((doc) async {
          await doc.reference.delete();
        });

        // Update the local state
        myWordSets[selectedVocaSet].removeAt(index);
        notifyListeners();
      }
    } catch (error) {
      print('Error deleting word: $error');
    }
  }
}

Map<String, dynamic> wordData = {
  'word': 'plant',
  'phonetics': 'plænt',
  'meanings': [
    {
      'partOfSpeech': 'Noun',
      'definitions': [
        {
          'meaning': '식물',
          'example': 'The plant needs water and sunlight to grow.',
          'translation': '식물은 성장하기 위해 물과 햇빛이 필요하다.',
        },
        {
          'meaning': '공장',
          'example': 'The car plant employs over 2,000 workers.',
          'translation': '그 자동차 공장은 2,000명 이상의 노동자를 고용한다.',
        },
      ],
    },
  ],
};
List<Map<String, dynamic>> test = [];
