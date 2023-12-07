import 'package:voca_app/models/definition.dart';
import 'package:voca_app/models/word_description.dart';

// 단어관련 함수
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

String getPartOfSpeech(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    return meanings.map((meaning) => meaning.partOfSpeech).join(', ');
  }
  return '';
}
