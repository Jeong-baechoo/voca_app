// lib/screens/dic_page.dart
import 'package:flutter/material.dart';
import 'package:voca_app/models/word_description.dart';
import 'package:voca_app/screens/dic_search_screen.dart';
import 'package:voca_app/widgets/input_dialog.dart';

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
          await showInputDialog(context, yourWordDescription);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
