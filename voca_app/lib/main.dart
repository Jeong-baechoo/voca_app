import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/screens/my_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => VocaProvider()),
    ChangeNotifierProvider(create: (context) => WordProvider()),
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
