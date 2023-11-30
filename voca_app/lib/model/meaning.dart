import 'package:voca_app/model/definition.dart';
import 'package:voca_app/model/wordDescription.dart';

class Meaning {
  String partOfSpeech;
  List<Definition> definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
        partOfSpeech: json["partOfSpeech"],
        definitions: List<Definition>.from(
            json["definitions"].map((x) => Definition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "partOfSpeech": partOfSpeech,
        "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
      };
}

String getPartOfSpeech(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    return meanings.map((meaning) => meaning.partOfSpeech).join(', ');
  }
  return '';
}
