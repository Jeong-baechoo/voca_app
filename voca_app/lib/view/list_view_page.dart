import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/main.dart';
import 'package:voca_app/provider/voca_provider.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() {
    return _ListViewPageState();
  }
}

class _ListViewPageState extends State<ListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어장 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemExtent: 100.0,
        itemCount: vocalbularySet.length,
        itemBuilder: (context, index) {
          return buildListItem(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewDialog();
        },
        child: const Icon(Icons.add),
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

  Future<void> _showEditDialog(int index) async {
    TextEditingController _controller = TextEditingController();

    return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 입력창
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '수정할 단어장 이름',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 취소 버튼
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 바텀 시트 닫기
                    },
                    child: const Text('취소'),
                  ),
                  // 확인 버튼
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        vocalbularySet[index] = _controller.text;
                      });
                      Navigator.pop(context); // 바텀 시트 닫기
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildListItem(int index) {
    return InkWell(
      onTap: () {
        Provider.of<VocaProvider>(context, listen: false).selectVocaSet(index);
        Navigator.pop(context);
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
                    _showEditDialog(index);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('삭제'),
                  onTap: () {
                    _showConfirmationDialog().then((value) {
                      if (value) {
                        setState(() {
                          vocalbularySet.removeAt(index); // 리스트에서 해당 항목 삭제
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Center(
                child: Text(vocalbularySet[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNewDialog() async {
    String newItem = ''; // 사용자가 입력한 새로운 아이템 이름

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새로운 단어장 추가'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: const InputDecoration(
              hintText: '새로운 단어장 이름',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (newItem.isNotEmpty) {
                  setState(() {
                    vocalbularySet.add(newItem); // 리스트에 새로운 아이템 추가
                  });
                }
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }
}
