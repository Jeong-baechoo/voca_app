import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voca_app/providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VocaProvider()),
        ChangeNotifierProvider(create: (_) => WordProvider()),
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => WordDescriptionProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> initdata;

  Future<void> initdataBase() async {
    await Provider.of<VocaProvider>(context, listen: false)
        .fetchAndSetVocabularySets();
    await Provider.of<WordProvider>(context, listen: false).initializeWords();
  }

  @override
  void didChangeDependencies() {
    // 이 메서드에서 context에 안전하게 접근 가능
    initdata = initdataBase();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initdata,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중이면 로딩 화면을 표시
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          // 에러가 있으면 에러 화면을 표시
          return const ErrorScreen();
        } else {
          // 로딩이 완료되면 MyHomePage로 이동
          return MyHomePage();
        }
      },
    );
  }
}

// 로딩 화면 위젯
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지
          Image.asset(
            './images/logo.jpeg',
            fit: BoxFit.cover,
          ),

          // 로딩 인디케이터
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

// 에러 화면 위젯
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Error occurred!"),
      ),
    );
  }
}
