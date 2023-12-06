import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:voca_app/chat_screen.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/model/definition.dart';
import 'package:voca_app/model/meaning.dart';
import 'package:voca_app/model/wordDescription.dart';

String apiResponseContent = '';

class DicPage extends StatelessWidget {
  const DicPage({super.key});

  @override
  Widget build(BuildContext context) {
    WordDescription? yourWordDescription;
    return Scaffold(
      body: ChatScreen(
        onWordDescriptionChanged: (newWordDescription) {
          yourWordDescription = newWordDescription;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showInputDialog(context, yourWordDescription);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _showInputDialog(
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
  TextEditingController memoController =
      TextEditingController(text: getCombinedExamples(yourWordDescription));

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
                _buildInputField('단어', wordController),
                _buildInputField('발음기호', phoneticsController),
                _buildInputField('품사', partOfSpeechController),
                _buildInputField('뜻', definitionController),
                _buildInputField('기타 메모', memoController),
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
              // // Access the values using the controllers
              // final String word = wordController.text;
              // final String partOfSpeech = partOfSpeechController.text;
              // final String definition = definitionController.text;
              // final String memo = memoController.text;

              // // Do something with the values (e.g., save to database)
              // // ...
              Map<String, dynamic> contentMap = json.decode(apiResponseContent);
              flashcardsList.add(contentMap);

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

Widget _buildInputField(String label, TextEditingController controller,
    {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
