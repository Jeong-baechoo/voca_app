import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //각 카테고리별 그리드 생성
            CategoryGrid(category: "추천", items: generateItems(6, "추천")),
            CategoryGrid(category: "기초", items: generateItems(6, "기초")),
            CategoryGrid(category: "초급", items: generateItems(6, "초급")),
            CategoryGrid(category: "중급", items: generateItems(6, "중급")),
            CategoryGrid(category: "고급", items: generateItems(6, "고급")),
          ],
        ),
      ),
    );
  }
  //아이템 목록 생성
  List<String> generateItems(int count, String category) {
    return List.generate(count, (index) => "$category 영단어 ${index + 1}");
  }
}

class CategoryGrid extends StatelessWidget {
  final String category;
  final List<String> items;

  CategoryGrid({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //카테고리명 표시
        Text(
          category,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        //그리드 생성
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, //한 행에 4개의 아이템
            childAspectRatio: 1.33, //가로와 세로의 비율 1.33:1
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return GridItem(item: items[index]);
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  final String item;

  GridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(item),
      ),
    );
  }
}