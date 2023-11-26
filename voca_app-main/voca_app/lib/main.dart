import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/detail_screen.dart';

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
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const RecomendPage(),
    const ListViewPage(),
    const DicPage(),
  ];

  final List<String> _titles = [
    '추천 단어장',
    '내 단어장',
    '사전검색',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('암기빵'),
        leading: _currentIndex != 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
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
                    ? Icons.star
                    : i == 1
                        ? Icons.home
                        : Icons.collections_bookmark_rounded,
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
  const ListViewPage({Key? key}) : super(key: key);

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
        builder: (context) => DetailScreen(
          flashcards: FlashCard().flashcards,
        ),
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

class DicPage extends StatelessWidget {
  const DicPage({Key? key}) : super(key: key);

  Future<void> _showInputDialog(BuildContext context) async {
    // Controllers for text fields
    TextEditingController wordController = TextEditingController();
    TextEditingController partOfSpeechController = TextEditingController();
    TextEditingController definitionController = TextEditingController();
    TextEditingController memoController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // Get the device width
        double deviceWidth = MediaQuery.of(context).size.width;
        double deviceHeight = MediaQuery.of(context).size.height;

        // Calculate the dialog width (you can adjust the margin as needed)
        double dialogWidth = deviceWidth - 20.0;
        double dialogHeight = deviceHeight - 315.0;

        return AlertDialog(
          title: const Text('새로운 단어 추가'),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField('단어', wordController),
                  _buildInputField('품사', partOfSpeechController),
                  _buildInputField('뜻', definitionController),
                  _buildInputField('기타 메모', memoController, maxLines: 7),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16.0), // 텍스트 크기 조절
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // Access the values using the controllers
                final String word = wordController.text;
                final String partOfSpeech = partOfSpeechController.text;
                final String definition = definitionController.text;
                final String memo = memoController.text;

                // Do something with the values (e.g., save to database)
                // ...

                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16.0), // 텍스트 크기 조절
              ),
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

// Helper method to build input fields
  Widget _buildInputField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          '사전 화면',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlashCard {
  List<Map<String, String>> flashcards = [
    {
      'word': 'candidate',
      'partOfSpeech': 'noun',
      'definition': '후보자, 지원자',
      'example': 'one of the leading candidates for the presidency',
      'exampleTranslation': '대통령 선거 유력 입후보자들 중 한 명',
    },
    {
      'word': 'client',
      'partOfSpeech': 'noun',
      'definition': '고객',
      'example': 'a lawyer with many famous clients',
      'exampleTranslation': '유명한 의뢰인이 많은 변호사',
    },
    {
      'word': 'colleague',
      'partOfSpeech': 'noun',
      'definition': '동료',
      'example': 'a colleague of mine from the office',
      'exampleTranslation': '내 사무실 동료들 중 한 명',
    },
    {
      'word': 'department',
      'partOfSpeech': 'noun',
      'definition': '부서',
      'example': 'the Department of Trade and Industry',
      'exampleTranslation': '무역산업부',
    },
    {
      'word': 'deserve',
      'partOfSpeech': 'verb',
      'definition': '받을만 하다',
      'example': 'You deserve a rest after all that hard work.',
      'exampleTranslation': '그렇게 힘든 일을 했으니 당신은 쉴 자격이 있어.',
    },
    {
      'word': 'employee',
      'partOfSpeech': 'noun',
      'definition': '직원',
      'example': 'The firm has over 500 employees.',
      'exampleTranslation': '그 회사는 종업원이 500명이 넘는다.',
    },
    {
      'word': 'promote',
      'partOfSpeech': 'verb',
      'definition': '홍보하다, 승진시키다',
      'example': 'She worked hard and was soon promoted.',
      'exampleTranslation': '그녀는 열심히 일해서 곧 승진되었다.',
    },
    {
      'word': 'regret',
      'partOfSpeech': 'verb',
      'definition': '후회하다, 유감',
      'example': "If you don’t do it now, you’ll only regret it.",
      'exampleTranslation': '네가 지금 그것을 하지 않으면 넌 후회만 하게 될 거야.',
    },
    {
      'word': 'absence',
      'partOfSpeech': 'noun',
      'definition': '결석, 부재',
      'example': 'absence from work',
      'exampleTranslation': '결근',
    },
    {
      'word': 'afford',
      'partOfSpeech': 'verb',
      'definition': '여유가 있다',
      'example': 'Can we afford a new car?',
      'exampleTranslation': '우리가 새 차를 살 여유가 돼요?',
    },
    {
      'word': 'aware',
      'partOfSpeech': 'adjective',
      'definition': '알고 있는',
      'example':
          "I don’t think people are really aware of just how much it costs.",
      'exampleTranslation': '난 사람들이 그저 그것에 돈이 얼마나 드는지도 제대로 자각하지 못한다고 생각한다.',
    },
    {
      'word': 'carelessness',
      'partOfSpeech': 'noun',
      'definition': '부주의',
      'example': 'a moment of carelessness',
      'exampleTranslation': '순간적인 부주의',
    },
    {
      'word': 'disappoint',
      'partOfSpeech': 'verb',
      'definition': '실망시키다',
      'example':
          'Her decision to cancel the concert is bound to disappoint her fans.',
      'exampleTranslation': '그녀의 그 콘서트 취소 결정은 틀림없이 팬들에게 실망을 안겨 줄 것이다.',
    },
    {
      'word': 'duty',
      'partOfSpeech': 'noun',
      'definition': '의무, 임무',
      'example': 'It is my duty to report it to the police.',
      'exampleTranslation': '그것을 경찰에 알리는 것이 내 의무이다.',
    },
    {
      'word': 'fulfill',
      'partOfSpeech': 'verb',
      'definition': '이행하다',
      'example': 'fulfill one\'s duties',
      'exampleTranslation': '임무를 수행하다',
    },
    {
      'word': 'beneficial',
      'partOfSpeech': 'adjective',
      'definition': '이로운',
      'example': 'A good diet is beneficial to health.',
      'exampleTranslation': '좋은 음식은 건강에 이롭다.',
    },
    {
      'word': 'irresponsible',
      'partOfSpeech': 'adjective',
      'definition': '무책임한',
      'example': 'an irresponsible teenager',
      'exampleTranslation': '무책임한 십대',
    },
    {
      'word': 'unfortunate',
      'partOfSpeech': 'adjective',
      'definition': '불행한, 유감스러운',
      'example': 'He was unfortunate to lose in the final round.',
      'exampleTranslation': '그는 운 나쁘게도 마지막 라운드에서 졌다.',
    },
    {
      'word': 'application',
      'partOfSpeech': 'noun',
      'definition': '적용, 응용',
      'example': 'the application of new technology to teaching',
      'exampleTranslation': '새로운 과학기술을 교수에 적용함',
    },
    {
      'word': 'chemistry',
      'partOfSpeech': 'noun',
      'definition': '화학',
      'example': 'a degree in chemistry',
      'exampleTranslation': '화학 학위',
    },
    {
      'word': 'coursework',
      'partOfSpeech': 'noun',
      'definition': '학습 과제, 교과 학습',
      'example': 'Coursework accounts for 40% of the final marks.',
      'exampleTranslation': '수업 활동이 기말 성적의 40%를 차지한다.',
    },
    {
      'word': 'electrical',
      'partOfSpeech': 'adjective',
      'definition': '전기의, 전자의',
      'example': 'an electrical fault in the engine',
      'exampleTranslation': '엔진의 전기 결함',
    },
    {
      'word': 'fascinated',
      'partOfSpeech': 'adjective',
      'definition': '매료된',
      'example':
          'The children watched, fascinated, as the picture began to appear.',
      'exampleTranslation': '영상이 나타나기 시작하자 아이들이 넋을 빼고 지켜보았다.',
    },
    {
      'word': 'flexible',
      'partOfSpeech': 'adjective',
      'definition': '유연한',
      'example': 'flexible plastic tubing',
      'exampleTranslation': '유연한 플라스틱 배관',
    },
    {
      'word': 'honored',
      'partOfSpeech': 'adjective',
      'definition': '명예로운, 영광으로 생각하여',
      'example': 'I feel highly honored by your kindness.',
      'exampleTranslation': '나는 당신의 친절을 큰 영광으로 생각합니다.',
    },
    {
      'word': 'independent',
      'partOfSpeech': 'adjective',
      'definition': '독립한, 무소속의',
      'example': 'an independent nation',
      'exampleTranslation': '독립한 국가',
    },
    {
      'word': 'introductory',
      'partOfSpeech': 'adjective',
      'definition': '소개의, 서두의',
      'example': 'introductory chapters',
      'exampleTranslation': '서론 부분이 되는 장들',
    },
    {
      'word': 'laboratory',
      'partOfSpeech': 'noun',
      'definition': '실험실',
      'example': 'a research laboratory',
      'exampleTranslation': '연구 실험실',
    },
    {
      'word': 'term',
      'partOfSpeech': 'noun',
      'definition': '용어, 기간',
      'example': 'a technical/legal/scientific, etc. term',
      'exampleTranslation': '전문[특수]/법률/과학 용어 등',
    },
    {
      'word': 'transparent',
      'partOfSpeech': 'adjective',
      'definition': '투명한',
      'example': 'a man of transparent honesty',
      'exampleTranslation': '투명한 정직성을 지닌 남자',
    }
  ];
}
