import 'package:test/test.dart';
import 'package:voca_app/models/word_description.dart';

void main() {
  group('WordDescription Tests', () {
    test('fromJson should create a WordDescription object from JSON', () {
      final json = {
        "word": "example",
        "phonetics": "/ɪɡˈzæmpəl/",
        "meanings": [
          {
            "partOfSpeech": "noun",
            "definitions": [
              {
                "meaning": "a representative form or pattern",
                "example": "I followed your example",
                "translation": "예를 들면"
              }
            ]
          }
        ]
      };

      final wordDescription = WordDescription.fromJson(json);

      expect(wordDescription.word, equals("example"));
      expect(wordDescription.phonetics, equals("/ɪɡˈzæmpəl/"));
      expect(wordDescription.meanings.length, equals(1));

      final meaning = wordDescription.meanings[0];
      expect(meaning.partOfSpeech, equals("noun"));
      expect(meaning.definitions.length, equals(1));

      final definition = meaning.definitions[0];
      expect(definition.meaning, equals("a representative form or pattern"));
      expect(definition.example, equals("I followed your example"));
      expect(definition.translation, equals("예를 들면"));
    });

    test('toJson should convert WordDescription object to JSON', () {
      final wordDescription = WordDescription.createWordDescription(
        word: "example",
        phonetics: "/ɪɡˈzæmpəl/",
        partOfSpeech: "noun",
        definition: "a representative form or pattern",
        example: "I followed your example",
        translate: "예를 들면",
      );

      final json = wordDescription.toJson();

      expect(json["word"], equals("example"));
      expect(json["phonetics"], equals("/ɪɡˈzæmpəl/"));
      expect(json["meanings"].length, equals(1));

      final meaning = json["meanings"][0];
      expect(meaning["partOfSpeech"], equals("noun"));
      expect(meaning["definitions"].length, equals(1));

      final definition = meaning["definitions"][0];
      expect(definition["meaning"], equals("a representative form or pattern"));
      expect(definition["example"], equals("I followed your example"));
      expect(definition["translation"], equals("예를 들면"));
    });
  });
}
