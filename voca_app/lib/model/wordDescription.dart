import 'package:voca_app/model/definition.dart';
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

  static WordDescription createWordDescription({
    required String word,
    required String phonetics,
    required String partOfSpeech,
    required String definition,
    required String example,
    required String translate,
  }) {
    // 단순성을 위해 하나의 의미와 정의만 있다고 가정합니다.
    Meaning meaning = Meaning(
      partOfSpeech: partOfSpeech,
      definitions: [
        Definition(
          meaning: definition,
          example: example, // 필요에 따라 수정 가능합니다.
          translation: translate,
        ),
      ],
    );

    return WordDescription(
      word: word,
      phonetics: phonetics,
      meanings: [meaning],
    );
  }
}
