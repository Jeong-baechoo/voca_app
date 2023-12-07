import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/provider/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/provider/voca_provider.dart';
import 'package:voca_app/view/my_home_page.dart';

List<String> vocalbularySet = ['내 단어장', 'Item : 1', 'Item : 2', 'Item : 3'];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => VocaProvider()),
    ChangeNotifierProvider(create: (context) => PageProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
