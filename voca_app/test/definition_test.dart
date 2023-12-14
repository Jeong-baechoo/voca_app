import 'package:test/test.dart';
import 'package:voca_app/models/definition.dart';

void main() {
  group('Definition Tests', () {
    test('fromJson should create a Definition object from JSON', () {
      final json = {
        "meaning": "a representative form or pattern",
        "example": "I followed your example",
        "translation": "예를 들면",
      };

      final definition = Definition.fromJson(json);

      expect(definition.meaning, equals("a representative form or pattern"));
      expect(definition.example, equals("I followed your example"));
      expect(definition.translation, equals("예를 들면"));
    });

    test('toJson should convert Definition object to JSON', () {
      final definition = Definition(
        meaning: "a representative form or pattern",
        example: "I followed your example",
        translation: "예를 들면",
      );

      final json = definition.toJson();

      expect(json["meaning"], equals("a representative form or pattern"));
      expect(json["example"], equals("I followed your example"));
      expect(json["translation"], equals("예를 들면"));
    });
  });
}
