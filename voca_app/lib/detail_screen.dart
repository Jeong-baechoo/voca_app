import 'package:flutter/material.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/filp_card_page.dart';

class DetailScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  const DetailScreen(
      {Key? key, required this.flashcards, required FlashCard flashcard})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isSecondButtonPressed = false;

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
        DropdownButton<String>(
          // 드롭다운 버튼 설정
          value: 'Dropdown Item 1', // 현재 선택된 아이템
          items: <String>[
            'Dropdown Item 1',
            'Dropdown Item 2',
            'Dropdown Item 3'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            // 드롭다운 아이템이 변경되었을 때 호출되는 콜백
            print('Selected: $newValue');
          },
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
        FloatingActionButton(
          /*TO DO: speed dial적용*/
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: isSecondButtonPressed
                ? const Icon(Icons.remove, key: Key('remove'))
                : const Icon(Icons.add, key: Key('add')),
          ),
          onPressed: () {
            setState(() {
              isSecondButtonPressed =
                  !isSecondButtonPressed; // 상태를 변경하여 UI를 업데이트
            });
            print('Second Floating Action Button Pressed');
          },
        ),
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
      itemCount: widget.flashcards.length,
      itemBuilder: (context, index) {
        final currentFlashcard = widget.flashcards[index];

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
              widget.flashcards.removeAt(index);
            });
          },
        );
      },
    );
  }
}
