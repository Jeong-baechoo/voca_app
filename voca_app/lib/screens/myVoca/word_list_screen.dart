import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
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
          const SizedBox(height: 20),
          buildMenuSection(context),
          const Divider(color: Colors.black),
          Expanded(
            child: buildSavedWordsList(context),
          ),
        ],
      ),
    );
  }
}
