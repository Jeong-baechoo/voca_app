import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/data/flash_card.dart';
import 'package:voca_app/detail_screen.dart';
import 'package:voca_app/dic_page.dart';
import 'package:voca_app/filp_card_page.dart';
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
    RecomendPage(),
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
                        body: ListScreen(flashCard: flashCard),
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
                        items[index] = 'Item : ${_controller.text}';
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
        /* TODO: 단어장 클릭시 이동할 데이터 가져오기 */
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
                          items.removeAt(index); // 리스트에서 해당 항목 삭제
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
                child: Text(items[index]),
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
