import 'package:flutter/material.dart';

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
