import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:voca_app/models/word_description.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/screens/dictionary/dic_page.dart';
import 'package:voca_app/screens/myVoca/filp_card_page.dart';
import 'package:voca_app/widgets/dialogs.dart';

//단어들 나열 위젯
Widget buildMyWordsList(context) {
  WordDescription? yourWordDescription;
  final currentVoca = Provider.of<VocaProvider>(context);
  final currentWordSet = Provider.of<WordProvider>(context).myWordSets;
  return Scaffold(
    backgroundColor: Colors.white,
    body: ListView.builder(
      itemCount: currentWordSet[currentVoca.selectedVocaSet].length,
      itemBuilder: (context, index) {
        final currentFlashcard =
            currentWordSet[currentVoca.selectedVocaSet][index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlipCardPage(selectedIndex: index, currentWord: currentWordSet, setIndex: currentVoca.selectedVocaSet,),
              ),
            );
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('수정'),
                      onTap: () {
                        Navigator.pop(context);
                        showInputDialog(context, yourWordDescription);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('삭제'),
                      onTap: () {
                        showConfirmationDialog(context).then((value) {
                          if (value) {
                            Provider.of<WordProvider>(context, listen: false)
                                .deleteWord(
                                    currentVoca.vocabularySets[
                                        currentVoca.selectedVocaSet],
                                    currentVoca.selectedVocaSet,
                                    index);
                            // 리스트에서 해당 항목 삭제
                          }
                          Navigator.pop(context); // 바텀 시트 닫기
                        });
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0xff, 0xfe, 0xfe),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset:
                      const Offset(0, 1), // changes the position of the shadow
                ),
              ],
              border: Border.all(color: Colors.grey), // Add border if needed
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentFlashcard['word'] as String,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                      Text('[${currentFlashcard['phonetics']}]'),
                    ],
                  ),
                  const SizedBox(width: 16), // Add spacing between columns
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var meaning in currentFlashcard['meanings'])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '[${meaning['partOfSpeech'] as String}]',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              for (var definition
                                  in meaning['definitions'] as List<dynamic>)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      definition['meaning'] as String,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              const SizedBox(
                                height: 8,
                              ), // Add some spacing between meanings
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    floatingActionButton: _getFAB(context),
  );
}

Widget _getFAB(context) {
  WordDescription? yourWordDescription;
  return SpeedDial(
    icon: Icons.add,
    activeIcon: Icons.undo_rounded,
    animatedIconTheme: const IconThemeData(size: 22),
    visible: true,
    curve: Curves.bounceIn,
    direction: SpeedDialDirection.up,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.search),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('사전 검색'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: const DicPage(),
              ),
            ),
          );
        },
        backgroundColor: Colors.lightBlue,
        label: ' 사전에서 추가',
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        labelBackgroundColor: Colors.lightBlue,
      ),
      SpeedDialChild(
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
        onTap: () async {
          showInputDialog(context, yourWordDescription);
        },
        label: '직접 추가',
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 16.0,
        ),
        labelBackgroundColor: Colors.lightBlue,
      ),
    ],
  );
}



Widget buildRecommendWordList(context, int setIndex) {
  final currentWordsSet = Provider.of<WordProvider>(context).recommendWordSets;
  return Scaffold(
    backgroundColor: Colors.white,
    body: ListView.builder(
      itemCount: currentWordsSet[setIndex].length,
      itemBuilder: (context, index) {
        final currentFlashcard =
        currentWordsSet[setIndex][index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlipCardPage(currentWord: currentWordsSet,setIndex: setIndex ,selectedIndex: index),
              ),
            );
          },

          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0xff, 0xfe, 0xfe),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset:
                  const Offset(0, 1), // changes the position of the shadow
                ),
              ],
              border: Border.all(color: Colors.grey), // Add border if needed
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentFlashcard['word'] as String,
                        style:
                        Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text('[${currentFlashcard['phonetics']}]'),
                    ],
                  ),
                  const SizedBox(width: 16), // Add spacing between columns
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var meaning in currentFlashcard['meanings'])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '[${meaning['partOfSpeech'] as String}]',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              for (var definition
                              in meaning['definitions'] as List<dynamic>)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      definition['meaning'] as String,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              const SizedBox(
                                height: 8,
                              ), // Add some spacing between meanings
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}