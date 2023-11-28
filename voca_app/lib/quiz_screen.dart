import 'package:flutter/material.dart';

import 'data/flash_card.dart';

class QuizChoice extends StatelessWidget {
  const QuizChoice({super.key, required this.flashCard});
  final FlashCard flashCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 종류 선택'),
      ),
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
                    // Handle button click
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
                        builder: (context) =>
                            SpellingQuizScreen(flashCard: flashCard),
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

class SpellingQuizScreen extends StatefulWidget {
  const SpellingQuizScreen({super.key, required this.flashCard});
  final FlashCard flashCard;
  @override
  // ignore: library_private_types_in_public_api
  _SpellingQuizScreenState createState() => _SpellingQuizScreenState(flashCard);
}

class _SpellingQuizScreenState extends State<SpellingQuizScreen> {
  int currentIndex = 0; // 현재 퀴즈 질문 인덱스
  TextEditingController answerController = TextEditingController();
  bool? isCorrect; // 사용자의 답변이 정확한지 추적하는 변수
  int score = 0; // 사용자의 점수
  List<Map<String, String>> quizQuestions = []; // 퀴즈 질문과 답변을 저장하는 리스트
  FocusNode answerFocusNode = FocusNode();

  _SpellingQuizScreenState(this.flashCard);
  final FlashCard flashCard;
  @override
  void initState() {
    super.initState();
    quizQuestions = getQuizQuestions();
  }

  // 섞인 퀴즈 질문 목록 반환
  List<Map<String, String>> getQuizQuestions() {
    List<Map<String, String>> flashcardsCopy = List.from(flashCard.flashcards);
    flashcardsCopy.shuffle();
    return flashcardsCopy.take(10).toList();
  }

  // 사용자의 답변을 정답과 비교
  void checkAnswer() {
    String userAnswer = answerController.text.toLowerCase().trim();
    String correctAnswer =
        quizQuestions[currentIndex]['word']!.toLowerCase().trim();

    setState(() {
      isCorrect = userAnswer == correctAnswer; // 비교에 기반하여 isCorrect 설정
      if (isCorrect!) score++; // 답이 정확하면 점수 증가
    });

    Future.delayed(const Duration(seconds: 5), nextQuestion);
  }

  void nextQuestion() {
    setState(() {
      if (currentIndex < quizQuestions.length - 1) {
        currentIndex++; // 다음 질문으로 이동
        answerController.clear(); // 답변 입력 필드 지우기
        isCorrect = null;
        answerFocusNode.requestFocus();
      } else {
        showScore(); // 모든 질문에 답한 경우 최종 점수 표시
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
                resetQuiz(); // 새 라운드를 위해 퀴즈 재설정
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
                  )),
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
