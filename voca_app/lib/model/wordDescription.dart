import 'package:voca_app/model/meaning.dart';

class WordDescription {
  String word;
  String phonetics;
  List<Meaning> meanings;

  WordDescription({
    required this.word,
    required this.phonetics,
    required this.meanings,
  });

  factory WordDescription.fromJson(Map<String, dynamic> json) =>
      WordDescription(
        word: json["word"],
        phonetics: json["phonetics"],
        meanings: List<Meaning>.from(
            json["meanings"].map((x) => Meaning.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "phonetics": phonetics,
        "meanings": List<dynamic>.from(meanings.map((x) => x.toJson())),
      };
}
