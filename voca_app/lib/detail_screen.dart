import 'package:flutter/material.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/dic_page.dart';
import 'package:voca_app/filp_card_page.dart';
import 'package:voca_app/main.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:voca_app/model/wordDescription.dart';

class DetailScreen extends StatefulWidget {
  final FlashCard flashCard;
  const DetailScreen({Key? key, required this.flashCard}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isSecondButtonPressed = false;
  static FlashCard flashCard = FlashCard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildMenuSection(context),
          const Divider(color: Colors.black),
          Expanded(
            child: _buildSavedWordsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            // '단어장 선택' 텍스트를 눌렀을 때의 동작을 여기에 추가
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('단어장 선택'),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    body: ListViewPage(flashCard: flashCard),
                  ),
                ));
          },
          child: const Text(
            '단어장 선택',
            style: TextStyle(
              // 스타일은 필요에 따라 변경 가능
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // 원하는 색상
            ),
          ),
        ),
      ],
    );
  }

  Widget _getFAB() {
    WordDescription? yourWordDescription;
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.undo_rounded,
      animatedIconTheme: const IconThemeData(size: 22),
      visible: true,
      curve: Curves.bounceIn,
      direction: SpeedDialDirection.up,
      children: [
        // FAB 1
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
                  ));
            },
            backgroundColor: Colors.lightBlue,
            label: ' 사전에서 추가',
            labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.0),
            labelBackgroundColor: Colors.lightBlue),
        SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.lightBlue,
            onTap: () async {
              _showInputDialog(context, yourWordDescription);
            },
            label: '직접 추가',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.lightBlue),
      ],
    );
  }

  Future<void> _showInputDialog(
    BuildContext context,
    WordDescription? yourWordDescription,
  ) async {
    TextEditingController wordController =
        TextEditingController(text: yourWordDescription?.word);
    TextEditingController phoneticsController =
        TextEditingController(text: yourWordDescription?.phonetics);
    TextEditingController partOfSpeechController = TextEditingController();
    TextEditingController definitionController = TextEditingController();
    TextEditingController memoController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        double deviceWidth = MediaQuery.of(context).size.width;
        double deviceHeight = MediaQuery.of(context).size.height;
        double dialogWidth = deviceWidth - 20.0;
        double dialogHeight = deviceHeight - 315.0;

        return AlertDialog(
          title: const Text('새로운 단어 추가'),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField('단어', wordController),
                  _buildInputField('발음기호', phoneticsController),
                  _buildInputField('품사', partOfSpeechController),
                  _buildInputField('뜻', definitionController),
                  _buildInputField('기타 메모', memoController),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // Access the values using the controllers
                final String word = wordController.text;
                final String partOfSpeech = partOfSpeechController.text;
                final String definition = definitionController.text;
                final String memo = memoController.text;

                // Do something with the values (e.g., save to database)
                // ...

                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('확인'),
              content: const Text('이 항목을 삭제하시겠습니까?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // 삭제 취소
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // 삭제 확인
                  },
                  child: const Text('삭제'),
                ),
              ],
            );
          },
        ) ??
        false; // 다이얼로그가 닫힐 경우 false 반환
  }

  Widget _buildSavedWordsList() {
    WordDescription? yourWordDescription;
    return Scaffold(
        body: ListView.builder(
          itemCount: widget.flashCard.flashcards.length,
          itemBuilder: (context, index) {
            final currentFlashcard = widget.flashCard.flashcards[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilpCardPage(),
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
                            _showInputDialog(context, yourWordDescription);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('삭제'),
                          onTap: () {
                            _showConfirmationDialog().then((value) {
                              if (value) {
                                setState(() {
                                  widget.flashCard.flashcards
                                      .removeAt(index); // 리스트에서 해당 항목 삭제
                                });
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
              child: Column(
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
              ),
            );
          },
        ),
        floatingActionButton: _getFAB());
  }
}
