import 'package:flutter/material.dart';

class QuizChoice extends StatelessWidget {
  const QuizChoice({Key? key, required this.flashcardsList}) : super(key: key);

  final List<Map<String, dynamic>> flashcardsList;

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
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Quiz(
                          flashcardsList: flashcardsList,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('단어보고 뜻 맞추기(객관식)',
                      style: TextStyle(fontSize: 17)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpellingQuizScreen(
                          flashcards: flashcardsList,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('뜻보고 단어 맞추기(객관식)',
                      style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  const Quiz({Key? key, required this.flashcardsList}) : super(key: key);

  final List<Map<String, dynamic>> flashcardsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz Screen',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle quiz logic
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Start Quiz', style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }
}

class SpellingQuizScreen extends StatefulWidget {
  const SpellingQuizScreen({Key? key, required this.flashcards})
      : super(key: key);

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

    Future.delayed(const Duration(seconds: 5), nextQuestion);
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
