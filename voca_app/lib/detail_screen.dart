import 'package:flutter/material.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/dic_page.dart';
import 'package:voca_app/filp_card_page.dart';
import 'package:voca_app/main.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
        const Spacer(),
        FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FilpCardPage(),
              ),
            );
          },
        ),
        const SizedBox(width: 16), // 추가한 부분: 간격 조절을 위한 SizedBox
        _getFAB(),
      ],
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22),
      visible: true,
      curve: Curves.bounceIn,
      direction: SpeedDialDirection.down,
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
            onTap: () {
              setState(() {
                //_counter = 0;
              });
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
    return ListView.builder(
      itemCount: widget.flashCard.flashcards.length,
      itemBuilder: (context, index) {
        final currentFlashcard = widget.flashCard.flashcards[index];

        return Dismissible(
          key: UniqueKey(),
          confirmDismiss: (direction) async {
            bool deleteConfirmed = await _showConfirmationDialog();
            return deleteConfirmed;
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilpCardPage(),
                ),
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
          ),
          onDismissed: (direction) {
            // 삭제가 완료되면 리스트에서도 해당 아이템을 제거
            setState(() {
              widget.flashCard.flashcards.removeAt(index);
            });
          },
        );
      },
    );
  }
}
