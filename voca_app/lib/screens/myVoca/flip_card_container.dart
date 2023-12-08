import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

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
            Text('[${flashCard['phonetics']}]')
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
