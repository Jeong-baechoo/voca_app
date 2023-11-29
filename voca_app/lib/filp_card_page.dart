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
      Map<String, String> flashCard, double screenWidth) {
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
                    FlashCard().flashcards.length,
                    (index) => _renderFlipCardContainer(
                        FlashCard().flashcards[index], screenWidth),
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
  final Map<String, String> flashCard;
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
                  color: Colors.black // 원하는 크기로 조절
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
              flashCard['partOfSpeech']!,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: containerWidth * 0.06, // 품사 폰트 크기를 폭의 6%로 조절
                    color: Colors.green, // 품사 텍스트의 색상을 초록색으로 변경
                  ),
            ),
            Text(
              flashCard['definition']!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: containerWidth * 0.1, // 폭의 10%
                    color: Colors.black, // 텍스트의 색상을 검정으로 변경
                  ),
            ),
            Text(
              flashCard['example']!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: containerWidth * 0.04, // 폭의 5%
                    color: Colors.black, // 텍스트의 색상을 검정으로 변경
                  ),
            ),
            Text(
              flashCard['exampleTranslation']!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: containerWidth * 0.05, // 폭의 5%
                    color: Colors.black, // 텍스트의 색상을 검정으로 변경
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListScreen extends StatefulWidget {
  final FlashCard flashCard;
  const ListScreen({Key? key, required this.flashCard}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSavedWordsList(),
    );
  }

  Widget _buildSavedWordsList() {
    return Scaffold(
        body: ListView.builder(
            itemCount: widget.flashCard.flashcards.length,
            itemBuilder: (context, index) {
              final currentFlashcard = widget.flashCard.flashcards[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentFlashcard['word']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '품사: ${currentFlashcard['partOfSpeech']!}',
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                currentFlashcard['definition']!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color.fromARGB(255, 170, 170, 170)),
                ],
              );
            }));
  }
}
