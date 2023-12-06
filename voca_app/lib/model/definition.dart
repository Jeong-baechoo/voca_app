import 'package:voca_app/model/wordDescription.dart';

class Definition {
  String meaning;
  String example;
  String translation;

  Definition({
    required this.meaning,
    required this.example,
    required this.translation,
  });

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        meaning: json["meaning"],
        example: json["example"],
        translation: json["translation"],
      );

  Map<String, dynamic> toJson() => {
        "meaning": meaning,
        "example": example,
        "translation": translation,
      };
}

String getCombinedDefinitions(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    List<Definition> allDefinitions =
        meanings.expand((meaning) => meaning.definitions).toList();
    return allDefinitions.map((definition) => definition.meaning).join('\n');
  }
  return '';
}

String getCombinedExamples(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    List<String> allExamples = meanings
        .expand((meaning) => meaning.definitions)
        .map(
            (definition) => '${definition.example} - ${definition.translation}')
        .toList();
    return allExamples.join('\n');
  }
  return '';
}
