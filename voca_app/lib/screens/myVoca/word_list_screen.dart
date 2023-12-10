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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: buildMenuSection(context),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: buildSavedWordsList(context),
          ),
        ],
      ),
    );
  }
}
