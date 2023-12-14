// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:test/test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:voca_app/models/word_description.dart';
// import 'package:voca_app/providers/word_description_provider.dart';
// import 'package:voca_app/services/api_service.dart';

// class MockClient extends Mock implements http.Client {}

// void main() {
//   group('ApiService Tests', () {
//     test(
//         'sendChatRequest should update word description on successful response',
//         () async {
//       final mockClient = MockClient();

//       final wordDescriptionProvider = WordDescriptionProvider();
//       final userInput = 'test input';

//       when(mockClient.post(
//         any,
//         headers: anyNamed('headers'),
//         body: anyNamed('body'),
//       )).thenAnswer((_) async => http.Response(
//             '{"choices": [{"message": {"content": "mocked response"}}]}',
//             200,
//           ));

//       await ApiService.sendChatRequest(
//         userInput: userInput,
//         wordDescriptionProvider: wordDescriptionProvider,
//       );

//       expect(wordDescriptionProvider.wordDescription?.word,
//           equals("mocked response"));
//     });

//     test('sendChatRequest should handle error response gracefully', () async {
//       final mockClient = MockClient();

//       final wordDescriptionProvider = WordDescriptionProvider();
//       final userInput = 'test input';

//       when(mockClient.post(
//         any,
//         headers: anyNamed('headers'),
//         body: anyNamed('body'),
//       )).thenAnswer(
//           (_) async => http.Response('{"error": "mocked error"}', 500));

//       await ApiService.sendChatRequest(
//         userInput: userInput,
//         wordDescriptionProvider: wordDescriptionProvider,
//       );

//       // Make sure the wordDescription remains unchanged in case of an error
//       expect(wordDescriptionProvider.wordDescription, equals(null));
//     });
//   });
// }
