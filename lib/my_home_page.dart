import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/page_provider.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/screens/myVoca/word_list_screen.dart';
import 'package:voca_app/screens/dictionary/dic_page.dart';
import 'package:voca_app/screens/quiz/quiz_screen.dart';
import 'package:voca_app/screens/recomend/recomend_page.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<Widget> _pages = [
    const WordListScreen(),
    const RecomendPage(),
    const QuizChoice(),
    const DicPage(),
  ];

  final List<String> _titles = [
    '내 단어장',
    '추천 단어장',
    '학습하기',
    '사전검색',
  ];

  @override
  Widget build(BuildContext context) {
    int currentPage = Provider.of<PageProvider>(context).selectedPage;
    return Scaffold(
      appBar: AppBar(
          title: Text(_titles[currentPage],
              style: const TextStyle(
                fontFamily: 'Cooper',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          elevation: 3,
          backgroundColor: const Color.fromARGB(255, 255, 214, 132)),
      body: _pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          Provider.of<WordDescriptionProvider>(context, listen: false)
              .initWordDescription();
          Provider.of<PageProvider>(context, listen: false).selectPage(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 94, 149, 235),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          for (int i = 0; i < _titles.length; i++)
            BottomNavigationBarItem(
              icon: Icon(
                i == 0
                    ? Icons.home
                    : i == 1
                        ? Icons.star
                        : i == 2
                            ? Icons.quiz
                            : Icons.search,
              ),
              label: _titles[i],
            ),
        ],
      ),
    );
  }
}
