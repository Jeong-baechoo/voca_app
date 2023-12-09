import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_app/providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/providers/word_provider.dart';
import 'package:voca_app/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voca_app/widgets/dialogs.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<VocaProvider>(context, listen: false)
          .fetchAndSetVocabularySets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingDialog(context);
        } else {
          return MyHomePage();
        }
      },
    );
  }
}
