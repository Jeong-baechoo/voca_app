import 'package:flutter/material.dart';
import 'package:voca_app/screens/quiz/questions_screen.dart';

List<String> usedWordsList = [];
List<String> correctMeanings = [];
late List<Map<String, dynamic>> quizQuestions;

class Quiz extends StatefulWidget {
  const Quiz({
    Key? key,
    required this.selectedVocaSet,
    required this.myWordSets,
  }) : super(key: key);

  final int selectedVocaSet;
  final List<List<Map<String, dynamic>>> myWordSets;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late int numTotalQuestions;
  late String activeScreen;
  List<String> selectedAnswer = [];

  @override
  void initState() {
    super.initState();
    switchScreen();
  }

  void switchScreen() {
    setState(() {
      numTotalQuestions = widget.myWordSets[widget.selectedVocaSet].length;
      activeScreen = 'questions-screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswer.add(answer);

    if (selectedAnswer.length == numTotalQuestions) {
      setState(() {
        activeScreen = 'result-screen';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget;

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: chooseAnswer,
        questions: widget.myWordSets[widget.selectedVocaSet],
      );
    } else {
      screenWidget = ResultScreen(
        chosenAnswers: selectedAnswer,
        restart: switchScreen,
        numTotalQuestions: numTotalQuestions,
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 214, 132),
        elevation: 3,
        title: const Text('4지선다'),
        leading: activeScreen == 'start-screen'
            ? null
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: screenWidget,
      ),
    );
  }
}

class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  final String text; //문제
  final List<String> answers; //보기들

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    // shuffledList.shuffle();
    return shuffledList;
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.chosenAnswers,
    required this.restart,
    required this.numTotalQuestions,
  });

  final List<String> chosenAnswers;
  final void Function() restart;
  final int numTotalQuestions;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': usedWordsList[i],
        'correct_answer': correctMeanings[i],
        'user_answer': chosenAnswers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numCorrectQuestions = summaryData.where((data) {
      return data['correct_answer'] == data['user_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionsSummary(summaryData),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                chosenAnswers.clear();
                usedWordsList.clear();
                correctMeanings.clear();
                restart();
              },
              icon: const Icon(Icons.refresh_outlined),
              label: const Text(
                'Restart Quiz!',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(
    this.summaryData, {
    super.key,
  });

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15), // 원하는 간격을 주세요
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionIdentifier(
                    isCorrectAnswer:
                        data['user_answer'] == data['correct_answer'],
                    questionIndex: data['question_index'] as int,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['question'] as String,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data['user_answer'] as String,
                          style: const TextStyle(color: Colors.pink),
                        ),
                        Text(
                          data['correct_answer'] as String,
                          style: const TextStyle(color: Colors.indigo),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class QuestionIdentifier extends StatelessWidget {
  const QuestionIdentifier({
    super.key,
    required this.isCorrectAnswer,
    required this.questionIndex,
  });

  final bool isCorrectAnswer;
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    final questionNumber = questionIndex + 1;

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCorrectAnswer
            ? const Color.fromARGB(255, 101, 185, 254)
            : const Color.fromARGB(255, 255, 108, 98),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        questionNumber.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
