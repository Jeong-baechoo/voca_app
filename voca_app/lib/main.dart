import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VocaProvider()),
        ChangeNotifierProvider(create: (context) => WordProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => WordDescriptionProvider()),
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
  void initState() {
    initdata = initdataBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initdata,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중이면 로딩 화면을 표시
          return LoadingScreen();
        } else if (snapshot.hasError) {
          // 에러가 있으면 에러 화면을 표시
          return ErrorScreen();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// 에러 화면 위젯
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Error occurred!"),
      ),
    );
  }
}
