import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voca_app/model/definition.dart';
import 'package:voca_app/model/wordDescription.dart';

class DicPage extends StatelessWidget {
  const DicPage({super.key});

  @override
  Widget build(BuildContext context) {
    WordDescription? yourWordDescription;
    return Scaffold(
      body: ChatScreen(
        onWordDescriptionChanged: (newWordDescription) {
          yourWordDescription = newWordDescription;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showInputDialog(context, yourWordDescription);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _showInputDialog(
  BuildContext context,
  WordDescription? yourWordDescription,
) async {
  TextEditingController wordController =
      TextEditingController(text: yourWordDescription?.word);
  TextEditingController phoneticsController =
      TextEditingController(text: yourWordDescription?.phonetics);
  TextEditingController partOfSpeechController =
      TextEditingController(text: _getPartOfSpeech(yourWordDescription));
  TextEditingController definitionController =
      TextEditingController(text: _getCombinedDefinitions(yourWordDescription));
  TextEditingController memoController =
      TextEditingController(text: _getCombinedExamples(yourWordDescription));

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      double deviceWidth = MediaQuery.of(context).size.width;
      double deviceHeight = MediaQuery.of(context).size.height;
      double dialogWidth = deviceWidth - 20.0;
      double dialogHeight = deviceHeight - 315.0;

      return AlertDialog(
        title: const Text('새로운 단어 추가'),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField('단어', wordController),
                _buildInputField('발음기호', phoneticsController),
                _buildInputField('품사', partOfSpeechController),
                _buildInputField('뜻', definitionController),
                _buildInputField('기타 메모', memoController),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 취소
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16.0),
            ),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // Access the values using the controllers
              final String word = wordController.text;
              final String partOfSpeech = partOfSpeechController.text;
              final String definition = definitionController.text;
              final String memo = memoController.text;

              // Do something with the values (e.g., save to database)
              // ...

              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16.0),
            ),
            child: const Text('추가'),
          ),
        ],
      );
    },
  );
}

String _getPartOfSpeech(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    return meanings.map((meaning) => meaning.partOfSpeech).join(', ');
  }
  return '';
}

String _getCombinedDefinitions(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    List<Definition> allDefinitions =
        meanings.expand((meaning) => meaning.definitions).toList();
    return allDefinitions
        .map((definition) =>
            '${definition.meaning}: ${definition.example} - ${definition.translation}')
        .join('\n');
  }
  return '';
}

String _getCombinedExamples(WordDescription? wordDescription) {
  var meanings = wordDescription?.meanings;

  if (meanings != null && meanings.isNotEmpty) {
    List<String> allExamples = meanings
        .expand((meaning) => meaning.definitions)
        .map((definition) => definition.example)
        .toList();
    return allExamples.join('\n');
  }
  return '';
}

Widget _buildInputField(String label, TextEditingController controller,
    {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.onWordDescriptionChanged});
  final Function(WordDescription) onWordDescriptionChanged;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController userInputController = TextEditingController();
  String apiResponseContent = '';
  WordDescription? wordDescription;

  Future<void> sendChatRequest() async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';
    final String openaiApiKey =
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
          "role": "user",
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
      print('Response: ${response.body}');

      // 응답에서 content를 추출하여 JSON 디코딩
      Map<String, dynamic> responseBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      String content = responseBody['choices'][0]['message']['content'];
      WordDescription wordDescriptionFromJson(String str) =>
          WordDescription.fromJson(json.decode(str));
      final newWordDescription = wordDescriptionFromJson(content);

      // print('Content: $content');
      // print(newWordDescription.word);
      // print(newWordDescription.phonetics);
      // newWordDescription.meanings.forEach((meaning) {
      //   print("Part of Speech: ${meaning.partOfSpeech}");
      //   meaning.definitions.forEach((definition) {
      //     print("  - Meaning: ${definition.meaning}");
      //     print("    Example: ${definition.example}");
      //     print("    Translation: ${definition.translation}");
      //   });
      //   print("");
      // });
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
                    Container(
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
                            '${wordDescription?.phonetics}',
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
                                  final int definitionIndex =
                                      defEntry.key + 1; // Definition numbering
                                  final Definition definition = defEntry.value;

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
