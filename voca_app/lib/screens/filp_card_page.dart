import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/screens/flip_card_container.dart';

class FilpCardPage extends StatelessWidget {
  const FilpCardPage({super.key, this.selectedIndex});
  final selectedIndex;
  Widget _renderBackground() {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 223, 223, 223)),
    );
  }

  Widget _renderFlipCardContainer(
      Map<String, dynamic> flashCard, double screenWidth) {
    return FlipCardContainer(
      flashCard: flashCard,
      containerWidth: screenWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipCard'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _renderBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Expanded(
                flex: 4,
                child: PageView(
                  controller: PageController(initialPage: selectedIndex),
                  children: List.generate(
                    flashcardsList.length,
                    (index) => _renderFlipCardContainer(
                        flashcardsList[index], screenWidth),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
