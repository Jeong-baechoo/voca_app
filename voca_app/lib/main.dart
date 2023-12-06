import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/detail_screen.dart';
import 'package:voca_app/dic_page.dart';
import 'package:voca_app/quiz_screen.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/recomend_page.dart';

import 'provider/select_voca_set_provider.dart';

List<String> vocalbularySet = ['내 단어장', 'Item : 1', 'Item : 2', 'Item : 3'];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ChangeNotifierProvider(
      create: (_) => VocaSetProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DetailScreen(),
    RecomendPage(),
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
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
