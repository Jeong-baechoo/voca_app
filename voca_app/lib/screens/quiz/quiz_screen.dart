import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/screens/quiz/mutiple_choice.dart';
import 'package:voca_app/screens/quiz/spelling_quiz_screen.dart';

class QuizChoice extends StatelessWidget {
  const QuizChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '어떤 퀴즈를 풀어볼까요?',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (BuildContext context) {
                       final wordProvider = Provider.of<WordProvider>(context);
                       final vocaProvider = Provider.of<VocaProvider>(context);
                      return Quiz(selectedVocaSet: vocaProvider.selectedVocaSet, myWordSets: wordProvider.myWordSets);
                  }
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('단어보고 뜻 맞추기(4지선다)',
                  style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle button click
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('뜻보고 단어 맞추기(4지선다)',
                  style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle button click
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child:
                  const Text('단어보고 뜻 맞추기(객관식)', style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpellingQuizScreen(
                      flashcards: Provider.of<WordProvider>(context).myWordSets[Provider.of<VocaProvider>(context).selectedVocaSet],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child:
                  const Text('뜻보고 단어 맞추기(객관식)', style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }
}
