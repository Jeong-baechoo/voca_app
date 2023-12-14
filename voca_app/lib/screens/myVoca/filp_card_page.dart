import 'package:flutter/material.dart';
import 'package:voca_app/screens/myVoca/flip_card_container.dart';

class FlipCardPage extends StatelessWidget {
  const FlipCardPage({Key? key, required this.selectedIndex, required this.currentWord, required this.setIndex}) : super(key: key);
  final int setIndex;
  final List<List<Map<String, dynamic>>> currentWord;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 214, 132),
        elevation: 1,
        title: const Text('FlipCard'),
      ),
      body: Container(
        decoration:
        const BoxDecoration(color: Color.fromARGB(255, 223, 223, 223)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            Expanded(
              flex: 4,
              child: PageView.builder(
                controller: PageController(initialPage: selectedIndex),
                itemCount: currentWord[setIndex].length,
                itemBuilder: (context, index) {
                  return FlipCardContainer(
                    flashCard: currentWord[setIndex][index],
                    containerWidth: screenWidth,
                  );
                },
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
