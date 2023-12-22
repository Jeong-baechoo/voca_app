import 'package:flutter/material.dart';
import 'package:voca_app/widgets/build_word_list.dart';
import 'package:voca_app/widgets/common_widgets.dart';

//현재 선택된 단어장의 단어들을 나열
class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});

  final isSecondButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            alignment: Alignment.centerLeft,
            child: buildMenuSection(context),
          ),
          Expanded(
            child: buildMyWordsList(context),
          ),
        ],
      ),
    );
  }
}
