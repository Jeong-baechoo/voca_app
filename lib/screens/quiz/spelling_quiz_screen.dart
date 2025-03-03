import 'package:flutter/material.dart';

class SpellingQuizScreen extends StatefulWidget {
  const SpellingQuizScreen({super.key, required this.flashcards});

  final List<Map<String, dynamic>> flashcards;

  @override
  _SpellingQuizScreenState createState() => _SpellingQuizScreenState();
}

class _SpellingQuizScreenState extends State<SpellingQuizScreen> {
  int currentIndex = 0;
  TextEditingController answerController = TextEditingController();
  bool? isCorrect;
  int score = 0;
  List<Map<String, String>> quizQuestions = [];
  FocusNode answerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    quizQuestions = getQuizQuestions();
  }

  List<Map<String, String>> getQuizQuestions() {
    List<Map<String, String>> flashcardsCopy =
        List.from(widget.flashcards.map((card) {
      return {
        'word': card['word'] as String,
        'definition':
            card['meanings'][0]['definitions'][0]['meaning'] as String,
      };
    }));
    flashcardsCopy.shuffle();
    return flashcardsCopy.take(10).toList();
  }

  void checkAnswer() {
    String userAnswer = answerController.text.toLowerCase().trim();
    String correctAnswer =
        quizQuestions[currentIndex]['word']!.toLowerCase().trim();

    setState(() {
      isCorrect = userAnswer == correctAnswer;
      if (isCorrect!) score++;
    });

    Future.delayed(const Duration(milliseconds: 500), nextQuestion);
  }

  void nextQuestion() {
    setState(() {
      if (currentIndex < quizQuestions.length - 1) {
        currentIndex++;
        answerController.clear();
        isCorrect = null;
        answerFocusNode.requestFocus();
      } else {
        showScore();
      }
    });
  }

  void showScore() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('퀴즈 완료'),
          content: Text('점수: $score / 10'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetQuiz();
              },
              child: const Text('다시 진행'),
            ),
          ],
        );
      },
    );
  }

  void resetQuiz() {
    setState(() {
      currentIndex = 0;
      score = 0;
      quizQuestions = getQuizQuestions();
      answerController.clear();
      isCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('스펠링 퀴즈 (${currentIndex + 1}/${quizQuestions.length})'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${quizQuestions[currentIndex]['definition']}',
                style: const TextStyle(fontSize: 50.0),
              ),
              const SizedBox(height: 20.0),
              TextField(
                focusNode: answerFocusNode,
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: '스펠링 입력',
                ),
                onEditingComplete: () {
                  checkAnswer();
                  answerFocusNode.unfocus();
                },
              ),
              const SizedBox(height: 20.0),
              if (isCorrect != null)
                Column(
                  children: [
                    Text(
                      isCorrect! ? '정답' : '오답',
                      style: TextStyle(
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                        color: isCorrect! ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '${quizQuestions[currentIndex]['word']}',
                      style: const TextStyle(
                        fontSize: 60.0,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              Visibility(
                visible: isCorrect == null,
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: passQuestion,
                    child: const Text('Pass'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passQuestion() {
    setState(() {
      isCorrect = false;
      nextQuestion();
    });
  }
}
