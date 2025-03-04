import 'package:flutter/material.dart';
import 'package:voca_app/screens/quiz/mutiple_choice.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
    required this.questions,
  });

  final void Function(String answer) onSelectAnswer;
  final List<Map<String, dynamic>> questions;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late QuizQuestion currentQuestion;
  Set<String> usedWords = <String>{}; // Track used words

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    final List<Map<String, dynamic>> shuffledList = List.from(widget.questions);
    shuffledList.shuffle();
    quizQuestions = shuffledList;
    Map<String, dynamic>? correctAnswer;
    for (final word in shuffledList) {
      if (!usedWords.contains(word['word'])) {
        correctAnswer = word;
        break;
      }
    }

    if (correctAnswer == null) {
      // All words have been used, handle this case as you see fit
      return;
    }

    final String correctWord = correctAnswer['word'] as String;
    final String correctMeaning = (correctAnswer['meanings'] as List<dynamic>?)
            ?.first['definitions'][0]['meaning']
            .toString() ??
        '';
    correctMeanings.add(correctMeaning);
    final List<String> incorrectWords = shuffledList
        .where((word) => word != correctAnswer)
        .take(3)
        .map((word) => (word['meanings'] as List<dynamic>)
            .first['definitions'][0]['meaning']
            .toString())
        .toList();

    final List<String> allMeanings = [correctMeaning, ...incorrectWords];
    allMeanings.shuffle();

    setState(() {
      currentQuestion = QuizQuestion(correctWord, allMeanings);
    });
  }

  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    usedWords.add(currentQuestion.text); // Track used words for correct order
    usedWordsList.add(currentQuestion.text);
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ...currentQuestion.getShuffledAnswers().map((answer) {
              return AnswerButton(
                answerText: answer,
                onTap: () {
                  answerQuestion(answer);
                },
              );
            })
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onTap,
  });

  final String answerText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 7, horizontal: 5), // 원하는 간격을 주세요
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          backgroundColor: const Color.fromARGB(255, 94, 149, 235),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Text(
          answerText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
