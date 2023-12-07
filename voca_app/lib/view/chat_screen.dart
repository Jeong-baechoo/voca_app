import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voca_app/model/definition.dart';
import 'package:voca_app/model/wordDescription.dart';
import 'package:http/http.dart' as http;
import 'package:voca_app/view/dic_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.onWordDescriptionChanged});
  final Function(WordDescription) onWordDescriptionChanged;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController userInputController = TextEditingController();
  WordDescription? wordDescription;

  Future<void> sendChatRequest() async {
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';
    const String openaiApiKey =
        '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';

    String userInput = userInputController.text;
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
      // HTTP 요청이 성공하면 여기에서 응답을 처리할 수 있습니다.
      // print('Response: ${response.body}');

      // 응답에서 content를 추출하여 JSON 디코딩
      Map<String, dynamic> responseBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(responseBody);
      String content = responseBody['choices'][0]['message']['content'];
      WordDescription wordDescriptionFromJson(String str) =>
          WordDescription.fromJson(json.decode(str));
      final newWordDescription = wordDescriptionFromJson(content);
      setState(() {
        wordDescription = newWordDescription;
        apiResponseContent = content;
      });
      if (wordDescription != null) {
        widget.onWordDescriptionChanged(wordDescription!);
      }
    } else {
      // HTTP 요청이 실패하면 여기에서 에러를 처리할 수 있습니다.
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dictionary',
                      style: theme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: userInputController,
                            decoration: const InputDecoration(
                              labelText: 'Enter a word',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: sendChatRequest,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Wrap the word description section with a Container
                    Visibility(
                      visible: wordDescription != null,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Word, Pronunciation, and Meanings sections...

                            Text(
                              '${wordDescription?.word}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '[${wordDescription?.phonetics}]',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ...?wordDescription?.meanings.map((meaning) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meaning.partOfSpeech,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ...meaning.definitions
                                      .asMap()
                                      .entries
                                      .map((defEntry) {
                                    final int definitionIndex = defEntry.key +
                                        1; // Definition numbering
                                    final Definition definition =
                                        defEntry.value;

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '  $definitionIndex. ${definition.meaning}'),
                                          const SizedBox(height: 12),
                                          Text('    ${definition.example}'),
                                          Text('    ${definition.translation}'),
                                          const SizedBox(height: 8)
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
