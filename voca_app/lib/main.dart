import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MyHomeScreen(),
    const GridViewPage(),
    HomePage(),
  ];

  final List<String> _titles = [
    '단어장 홈',
    '내 단어장',
    '프로필',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('암기빵'),
        leading: _currentIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              )
            : null,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          for (int i = 0; i < _titles.length; i++)
            BottomNavigationBarItem(
              icon: Icon(
                i == 0
                    ? Icons.home
                    : i == 1
                        ? Icons.star_border_sharp
                        : Icons.person,
              ),
              label: _titles[i],
            ),
        ],
      ),
    );
  }
}

class MyHomeScreen extends StatelessWidget {
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

  const CategoryGrid({required this.category, required this.items});

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
            return GridItem(item: items[index]);
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

  const GridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(item),
      ),
    );
  }
}

class GridViewPage extends StatefulWidget {
  const GridViewPage({Key? key}) : super(key: key);

  @override
  State<GridViewPage> createState() {
    return _GridViewPageState();
  }
}

class _GridViewPageState extends State<GridViewPage> {
  List<String> items = ['수능영단어', 'Item : 1', 'Item : 2', 'Item : 3'];
  List<String> savedWords = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
  ];
  void _onItemTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          savedWords: savedWords,
        ),
      ),
    );
  }

  Widget buildListItem(int index) {
    return InkWell(
      onLongPress: () {
        _onItemLongPress(index);
      },
      onTap: () {
        _onItemTap(index);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(items[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQuizButtonTap(int index) {
    // Implement quiz button click action here
  }

  void _onItemLongPress(int index) {
    setState(() {
      items.removeAt(index);
    });
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
          setState(() {
            // Add a new item to the list
            int newItemIndex = items.length;
            items.add('Item : $newItemIndex');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final List<String> savedWords;

  const DetailScreen({Key? key, required this.savedWords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 화면'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildQuizSection(context),
          Divider(color: Colors.black),
          Expanded(
            child: _buildSavedWordsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('퀴즈풀기'),
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSavedWordsList() {
    return ListView.builder(
      itemCount: savedWords.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(savedWords[index]),
              ),
              Divider(color: Colors.black),
            ],
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key});
  final List<String> frontTexts = ['apple', 'Front 2'];
  final List<String> backTexts = ['사과', 'Back 2'];
  Widget _renderBackground() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFFFFF)),
    );
  }

  Widget _renderAppBar(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0x00FFFFFF),
      ),
    );
  }

  Widget _renderFlipCardContainer(String frontText, String backText) {
    return Container(
      child: FlipCardContainer(
        frontText: frontText,
        backText: backText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlipCard'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _renderBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _renderAppBar(context),
              Expanded(
                flex: 4,
                child: PageView(
                  children: List.generate(
                    frontTexts.length,
                    (index) => _renderFlipCardContainer(
                      frontTexts[index],
                      backTexts[index],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FlipCardContainer extends StatelessWidget {
  final String frontText;
  final String backText;

  const FlipCardContainer(
      {Key? key, required this.frontText, required this.backText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      speed: 1000,
      onFlipDone: (status) {
        print(status);
      },
      front: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(frontText, style: Theme.of(context).textTheme.headline1),
            Text('Click here to flip back',
                style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
      back: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(backText, style: Theme.of(context).textTheme.headline1),
            Text('Click here to flip front',
                style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
