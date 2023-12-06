import 'package:flutter/material.dart';

class RecomendPage extends StatelessWidget {
  RecomendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 각 카테고리별 그리드 생성
            CategoryGrid(category: "추천", items: generateItems(6, _recotitles)),
            //CategoryGrid(category: "기초", items: generateItems(6, "기초")),
            //CategoryGrid(category: "초급", items: generateItems(6, "초급")),
            //CategoryGrid(category: "중급", items: generateItems(6, "중급")),
            //CategoryGrid(category: "고급", items: generateItems(6, "고급")),
          ],
        ),
      ),
    );
  }

  final List<String> _recotitles = [
    '수능 영단어',
    '토익 영단어',
    '토플 영단어',
    '토스 영단어',
    '오픽 영단어',
    '기타 영단어'
  ];

  // 아이템 목록 생성
  List<String> generateItems(int count, List recotitle) {
    return List.generate(count, (index) => recotitle[index]);
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
        // 카테고리명 표시
        Text(
          category,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // 그리드 생성
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 한 행에 4개의 아이템
            childAspectRatio: 1.33, // 가로와 세로의 비율 1.33:1
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('단어장'),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        // body: DetailScreen(flashcardsList: flashcardsList2),
                      ),
                    ));
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

class GridItem extends StatelessWidget {
  final String item;

  const GridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 250, 199), // 원하는 색상으로 변경
      child: Center(
        child: Text(item),
      ),
    );
  }
}
