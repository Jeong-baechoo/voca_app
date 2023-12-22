// lib/widgets/common_widgets.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca_app/providers/voca_provider.dart';
import 'package:voca_app/screens/myVoca/list_view_page.dart';

Widget buildInputField(String label, TextEditingController controller,
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

Widget buildMenuSection(BuildContext context) {
  final vocabularySet = Provider.of<VocaProvider>(context).vocabularySets;

  return InkWell(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ListViewPage()));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.toc_sharp, // Replace with the desired icon
            size: 24,
            color: Colors.blue, // Adjust the color as needed
          ),
          const SizedBox(width: 10), // Add some space between icon and text
          Text(
            vocabularySet[Provider.of<VocaProvider>(context).selectedVocaSet],
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
