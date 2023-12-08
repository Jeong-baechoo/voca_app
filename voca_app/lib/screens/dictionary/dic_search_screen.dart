import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/models/definition.dart';
import 'package:voca_app/providers/word_description_provider.dart';
import 'package:voca_app/services/api_service.dart';

//사전의 검색 결과가 나타남
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final TextEditingController userInputController = TextEditingController();

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
                          onPressed: () {
                            ApiService.sendChatRequest(
                                userInput: userInputController.text,
                                wordDescriptionProvider:
                                    Provider.of<WordDescriptionProvider>(
                                        context,
                                        listen: false));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Wrap the word description section with a Container
                    Consumer<WordDescriptionProvider>(builder: (context,
                        WordDescriptionProvider value, Widget? child) {
                      final wordDescription = value.wordDescription;
                      return Visibility(
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
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '  $definitionIndex. ${definition.meaning}'),
                                            const SizedBox(height: 12),
                                            Text('    ${definition.example}'),
                                            Text(
                                                '    ${definition.translation}'),
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
                      );
                    }),
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
