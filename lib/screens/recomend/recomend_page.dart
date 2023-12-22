import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/widgets/build_word_list.dart';

class RecomendPage extends StatelessWidget {
  const RecomendPage({super.key});

  @override
  Widget build(BuildContext context) {
    var recommendVocaSet = Provider.of<VocaProvider>(context).recommendVocaSet;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoryGrid(category: "추천", items: recommendVocaSet),
          ],
        ),
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final String category;
  final List<String> items;
  const CategoryGrid({super.key, required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.33,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(index: index),
                  ),
                );
              },
              child: GridItem(item: items[index]),
            );
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;

  const DetailPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendVocaSet = Provider.of<VocaProvider>(context).recommendVocaSet;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 214, 132),
        elevation: 3,
        title: Text(recommendVocaSet[index]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: buildRecommendWordList(context,index),
    );
  }
}

class GridItem extends StatelessWidget {
  final String item;

  const GridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 250, 199),
      child: Center(
        child: Text(item),
      ),
    );
  }
}
