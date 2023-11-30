import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:voca_app/data/flash_card.dart';

class FilpCardPage extends StatelessWidget {
  const FilpCardPage({super.key});

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

class FlipCardContainer extends StatelessWidget {
  final Map<String, dynamic> flashCard;
  final double containerWidth; // 화면 가로 폭에 따른 컨테이너 폭

  const FlipCardContainer({
    Key? key,
    required this.flashCard,
    required this.containerWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      speed: 1000,
      front: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              flashCard['word']!,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: containerWidth * 0.1,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
      back: Container(
        width: containerWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              flashCard['meanings'][0]['partOfSpeech']!,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: containerWidth * 0.06,
                    color: Colors.green,
                  ),
            ),
            Text(
              flashCard['meanings'][0]['definitions'][0]['meaning']!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: containerWidth * 0.1,
                    color: Colors.black,
                  ),
            ),
            Text(
              flashCard['meanings'][0]['definitions'][0]['example']!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: containerWidth * 0.04,
                    color: Colors.black,
                  ),
            ),
            Text(
              flashCard['meanings'][0]['definitions'][0]['translation']!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: containerWidth * 0.05,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
