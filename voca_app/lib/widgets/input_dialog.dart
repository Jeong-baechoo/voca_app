// lib/widgets/input_dialog.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voca_app/models/word_description.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/utilities/word_utils.dart';
import 'package:voca_app/widgets/common_widgets.dart';

String apiResponseContent = '';
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
