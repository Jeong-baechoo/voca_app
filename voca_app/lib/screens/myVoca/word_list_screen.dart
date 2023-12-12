import 'package:flutter/material.dart';
import 'package:voca_app/widgets/build_word_list.dart';
import 'package:voca_app/widgets/common_widgets.dart';

//현재 선택된 단어장의 단어들을 나열
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  final isSecondButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0xd9, 0xd9, 0xd6),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            alignment: Alignment.centerLeft,
            child: buildMenuSection(context),
          ),
          Expanded(
            child: buildSavedWordsList(context),
          ),
        ],
      ),
    );
  }
}
