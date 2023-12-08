import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/widgets/dialogs.dart';

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

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
        itemCount: Provider.of<VocaProvider>(context).vocabularySets.length,
        itemBuilder: (context, index) {
          return buildListItem(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNewDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
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
                    showEditDialog(context, index);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('삭제'),
                  onTap: () {
                    showConfirmationDialog(context).then((value) {
                      if (value) {
                        Provider.of<VocaProvider>(context, listen: false)
                            .deleteVocabularySet(index); // 리스트에서 해당 항목 삭제
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
                child: Text(
                    Provider.of<VocaProvider>(context).vocabularySets[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
