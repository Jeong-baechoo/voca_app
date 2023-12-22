// lib/widgets/input_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/models/word_description.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/utilities/word_utils.dart';
import 'package:voca_app/widgets/common_widgets.dart';

String apiResponseContent = '';

//단어 추가 다이얼로그 (사전)
Future<void> showInputDialog(
  BuildContext context,
  WordDescription? yourWordDescription,
) async {
  TextEditingController wordController =
      TextEditingController(text: yourWordDescription?.word);
  TextEditingController phoneticsController =
      TextEditingController(text: yourWordDescription?.phonetics);
  TextEditingController partOfSpeechController =
      TextEditingController(text: getPartOfSpeech(yourWordDescription));
  TextEditingController definitionController =
      TextEditingController(text: getCombinedDefinitions(yourWordDescription));
  TextEditingController exampleController =
      TextEditingController(text: getCombinedExamples(yourWordDescription));
  TextEditingController translateController =
      TextEditingController(text: getCombinedtranslates(yourWordDescription));
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      double deviceWidth = MediaQuery.of(context).size.width;
      double deviceHeight = MediaQuery.of(context).size.height;
      double dialogWidth = deviceWidth - 20.0;
      double dialogHeight = deviceHeight - 315.0;

      return AlertDialog(
        title: const Text('새로운 단어 추가'),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInputField('단어', wordController),
                buildInputField('발음기호', phoneticsController),
                buildInputField('품사', partOfSpeechController),
                buildInputField('뜻', definitionController),
                buildInputField('예문', exampleController),
                buildInputField('해석', translateController),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 취소
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16.0),
            ),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final createWordDescription =
                  WordDescription.createWordDescription(
                      word: wordController.text,
                      phonetics: phoneticsController.text,
                      partOfSpeech: partOfSpeechController.text,
                      definition: definitionController.text,
                      example: exampleController.text,
                      translate: translateController.text);

              VocaProvider vocaProvider =
                  Provider.of<VocaProvider>(context, listen: false);
              Provider.of<WordProvider>(context, listen: false).addWord(
                  vocaProvider.selectedVocaSet,
                  vocaProvider.vocabularySets[vocaProvider.selectedVocaSet],
                  createWordDescription);

              apiResponseContent = '';
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16.0),
            ),
            child: const Text('추가'),
          ),
        ],
      );
    },
  );
}

//단어삭제 다이얼로그
Future<bool> showConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('확인'),
            content: const Text('이 항목을 삭제하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // 삭제 취소
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // 삭제 확인
                },
                child: const Text('삭제'),
              ),
            ],
          );
        },
      ) ??
      false; // 다이얼로그가 닫힐 경우 false 반환
}

//딘어장 수정 다이얼로그
Future<void> showEditDialog(BuildContext context, int index) async {
  TextEditingController controller = TextEditingController();

  return await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 입력창
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '수정할 단어장 이름',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 취소 버튼
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 바텀 시트 닫기
                  },
                  child: const Text('취소'),
                ),
                // 확인 버튼
                ElevatedButton(
                  onPressed: () {
                    Provider.of<VocaProvider>(context, listen: false)
                        .updateVocabularySet(index, controller.text);

                    Navigator.pop(context); // 바텀 시트 닫기
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// 단어장 추가 다이얼로그
Future<void> showNewDialog(BuildContext context) async {
  String newItem = ''; // 사용자가 입력한 새로운 아이템 이름

  return await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('새로운 단어장 추가'),
        content: TextField(
          onChanged: (value) {
            newItem = value;
          },
          decoration: const InputDecoration(
            hintText: '새로운 단어장 이름',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 취소
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (newItem.isNotEmpty) {
                Provider.of<VocaProvider>(context, listen: false)
                    .addVocabularySet(newItem);
                final wocaProvider =
                    Provider.of<WordProvider>(context, listen: false);
                wocaProvider.myWordSets.add([]); //로컬에 새로 만든 단어장에 빈 단어리스트 넣기
              }
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: const Text('추가'),
          ),
        ],
      );
    },
  );
}

Widget buildLoadingDialog(BuildContext context) {
  return Stack(
    children: [
      // 전체 화면 어둡게 하는 배경
      Positioned.fill(
        child: Container(
          color: Colors.blue, // 배경 색상 설정
        ),
      ),
      // 암기빵이라고 적힌 위젯
      const Center(
        child: Text(
          '암기빵',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
