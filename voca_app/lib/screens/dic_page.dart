import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/models/word_description.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/screens/dic_search_screen.dart';
import 'package:voca_app/widgets/dialogs.dart';

class DicPage extends StatelessWidget {
  const DicPage({super.key});

  @override
  Widget build(context) {
    WordDescriptionProvider wordDescriptionProvider =
        Provider.of<WordDescriptionProvider>(context);
    WordDescription? yourWordDescription =
        wordDescriptionProvider.wordDescription;

    return Scaffold(
      body: ChatScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showInputDialog(context, yourWordDescription);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
