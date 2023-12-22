import 'package:test/test.dart';
import 'package:voca_app/models/definition.dart';
import 'package:voca_app/models/meaning.dart';

void main() {
  group('Meaning Tests', () {
    test('fromJson should create a Meaning object from JSON', () {
      final json = {
        "partOfSpeech": "noun",
        "definitions": [
          {
            "meaning": "a representative form or pattern",
            "example": "I followed your example",
            "translation": "예를 들면"
          }
        ]
      };

      final meaning = Meaning.fromJson(json);

      expect(meaning.partOfSpeech, equals("noun"));
      expect(meaning.definitions.length, equals(1));

      final definition = meaning.definitions[0];
      expect(definition.meaning, equals("a representative form or pattern"));
      expect(definition.example, equals("I followed your example"));
      expect(definition.translation, equals("예를 들면"));
    });

    test('toJson should convert Meaning object to JSON', () {
      final meaning = Meaning(
        partOfSpeech: "noun",
        definitions: [
          Definition(
            meaning: "a representative form or pattern",
            example: "I followed your example",
            translation: "예를 들면",
          ),
        ],
      );

      final json = meaning.toJson();

      expect(json["partOfSpeech"], equals("noun"));
      expect(json["definitions"].length, equals(1));

      final definition = json["definitions"][0];
      expect(definition["meaning"], equals("a representative form or pattern"));
      expect(definition["example"], equals("I followed your example"));
      expect(definition["translation"], equals("예를 들면"));
    });
  });
}
