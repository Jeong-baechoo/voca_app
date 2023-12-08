import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voca_app/models/word_description.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/widgets/input_dialog.dart';

class ApiService {
  static Future<void> sendChatRequest({
    required String userInput,
    required WordDescriptionProvider wordDescriptionProvider,
  }) async {
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';
    const String openaiApiKey =
        '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';

    try {
      final Map<String, dynamic> requestData = {
        "model": "gpt-3.5-turbo-1106",
        "response_format": {"type": "json_object"},
        "messages": [
          {
            "role": "system",
            "content":
                "you're a korean-english dictionary assistant that, upon receiving English input, returns English pronunciation symbols, Korean meanings about parts of speech , parts of speech, English examples and trasnlate of English examples in JSON format."
          },
          {
            "role": "system",
            "content":
                "{\n  \"word\": \"plant\",\n  \"phonetics\": \"plænt\",\n  \"meanings\": [\n    {\n      \"partOfSpeech\": \"Noun\",\n      \"definitions\": [\n        {\n          \"meaning\": \"식물\",\n          \"example\": \"The plant needs water and sunlight to grow.\",\n          \"translation\": \"식물은 성장하기 위해 물과 햇빛이 필요하다.\"\n        },\n        {\n          \"meaning\": \"공장\",\n          \"example\": \"The car plant employs over 2,000 workers.\",\n          \"translation\": \"그 자동차 공장은 2,000명 이상의 노동자를 고용한다.\"\n        }\n      ]\n    },\n    {\n      \"partOfSpeech\": \"Verb\",\n      \"definitions\": [\n        {\n          \"meaning\": \"심다\",\n          \"example\": \"She likes to plant flowers in her garden.\",\n          \"translation\": \"그녀는 정원에 꽃을 심는 것을 좋아한다.\"\n        },\n        {\n          \"meaning\": \"배치하다\",\n          \"example\": \"They decided to plant trees along the roadside.\",\n          \"translation\": \"그들은 도로 양쪽에 나무를 심기로 결정했다.\"\n        }\n      ]\n    }\n  ]\n}"
          },
          {"role": "user", "content": userInput}
        ]
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openaiApiKey',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        String content = jsonDecode(utf8.decode(response.bodyBytes))['choices']
            [0]['message']['content'];
        print(content);
        WordDescription wordDescriptionFromJson(String str) =>
            WordDescription.fromJson(json.decode(str));
        final newWordDescription = wordDescriptionFromJson(content);
        apiResponseContent = content;

        wordDescriptionProvider.setWordDescription(newWordDescription);
      } else {
        print('오류: ${response.statusCode}');
        // 오류를 더 세련되게 처리하세요 (예: 사용자에게 오류 메시지 표시)
      }
    } catch (error) {
      print('예외: $error');
      // 예외를 더 세련되게 처리하세요 (예: 사용자에게 오류 메시지 표시)
    }
  }
}
