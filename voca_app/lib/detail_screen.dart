import 'package:flutter/material.dart';
import 'package:voca_app/filp_card_page.dart';

class DetailScreen extends StatelessWidget {
  final List<Map<String, String>> flashcards;

  const DetailScreen({Key? key, required this.flashcards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 화면'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildQuizSection(context),
          const Divider(color: Colors.black),
          Expanded(
            child: _buildSavedWordsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('퀴즈풀기', strutStyle: StrutStyle(fontSize: 20.0)),
        FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FilpCardPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSavedWordsList() {
    return ListView.builder(
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final currentFlashcard = flashcards[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FilpCardPage(),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentFlashcard['word']!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '품사: ${currentFlashcard['partOfSpeech']!}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          Text(
                            currentFlashcard['definition']!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black),
            ],
          ),
        );
      },
    );
  }
}
