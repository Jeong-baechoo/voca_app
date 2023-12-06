import 'package:flutter/material.dart';
import 'package:voca_app/data/flash_card.dart';

List<String> usedWordsList = [];
List<String> correctMeanings = [];
late List<Map<String, dynamic>> quizQuestions;

class Quiz extends StatefulWidget {
  List<Map<String, dynamic>> flashcardsList;

  Quiz({Key? key, required this.flashcardsList});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'questions-screen';
  List<String> selectedAnswer = [];
  static const numTotalQuestions = 4;

  void switchScreen() {
    setState(() {
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
    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: chooseAnswer,
        questions: flashcardsList,
      );
    }

    if (activeScreen == 'result-screen') {
      screenWidget = ResultScreen(
        chosenAnswers: selectedAnswer,
        restart: switchScreen,
        numTotalQuestions: numTotalQuestions,
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('4지선다'),
          leading: activeScreen == 'start-screen'
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
        ),
        body: Container(
          child: screenWidget,
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {Key? key}) : super(key: key);

  final void Function() startQuiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4지선다'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            const Text(
              '퀴즈 풀러가기!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 50),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 94, 149, 235),
                foregroundColor: Colors.white,
              ),
              onPressed: startQuiz,
              label: const Text('Start Test'),
              icon: const Icon(Icons.arrow_right_alt),
            )
          ],
        ),
      ),
    );
  }
}

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    Key? key,
    required this.onSelectAnswer,
    required this.questions,
  }) : super(key: key);

  final void Function(String answer) onSelectAnswer;
  final List<Map<String, dynamic>> questions;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late QuizQuestion currentQuestion;
  Set<String> usedWords = Set<String>(); // Track used words

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    final List<Map<String, dynamic>> shuffledList = List.from(widget.questions);
    shuffledList.shuffle();
    quizQuestions = shuffledList;
    // Find a new word that hasn't been used
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

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    Key? key,
    required this.answerText,
    required this.onTap,
  }) : super(key: key);

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

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    Key? key,
    required this.chosenAnswers,
    required this.restart,
    required this.numTotalQuestions,
  }) : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
    Key? key,
    required this.isCorrectAnswer,
    required this.questionIndex,
  }) : super(key: key);

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
