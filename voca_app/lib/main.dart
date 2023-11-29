import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/detail_screen.dart';
import 'package:voca_app/dic_page.dart';
import 'package:voca_app/quiz_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
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
  static FlashCard flashCard = FlashCard();

  final List<Widget> _pages = [
    DetailScreen(
      flashCard: flashCard,
    ),
    const RecomendPage(),
    QuizChoice(flashCard: flashCard),
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

class RecomendPage extends StatelessWidget {
  const RecomendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 각 카테고리별 그리드 생성
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

  // 아이템 목록 생성
  List<String> generateItems(int count, String category) {
    return List.generate(count, (index) => "$category 영단어 ${index + 1}");
  }
}

class CategoryGrid extends StatelessWidget {
  final String category;
  final List<String> items;
  static FlashCard flashCard = FlashCard();

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
                        body: DetailScreen(flashCard: flashCard),
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

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key, required this.flashCard}) : super(key: key);
  final FlashCard flashCard;

  @override
  State<ListViewPage> createState() {
    return _ListViewPageState();
  }
}

class _ListViewPageState extends State<ListViewPage> {
  List<String> items = ['Item : 1', 'Item :2', 'Item : 3'];

  void _onItemTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(flashCard: widget.flashCard),
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

  Widget buildListItem(int index) {
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
          _onItemTap(index);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Center(
                  child: Text("단어장 ${index + 1}"),
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // 삭제가 완료되면 리스트에서도 해당 아이템을 제거
        setState(() {
          items.removeAt(index);
        });
      },
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
                    items.add(newItem); // 리스트에 새로운 아이템 추가
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

  void _onQuizButtonTap(int index) {
    // Implement quiz button click action here
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemExtent: 100.0,
        itemCount: items.length,
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
}
