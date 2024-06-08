import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BotPage(),
    );
  }
}

class BotPage extends StatefulWidget {
  const BotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BotPageState createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bot',
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color.fromARGB(255, 31, 17, 55),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "What are your symptoms?",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> query(String text) async {
    const String apiUrl =
        "https://api-inference.huggingface.co/models/Zabihin/Symptom_to_Diagnosis";
    const Map<String, String> headers = {
      "Authorization":
          "Bearer for apikey", // Replace with your token
      "Content-Type": "application/json"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({"inputs": text}),
      );

      // print('Request Body: ${jsonEncode({"inputs": text})}');
      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // print('Parsed Response Body: $responseBody');

        if (responseBody is List && responseBody.isNotEmpty) {
          final List<String> diagnosisLabels = [];
          for (var diagnosis in responseBody[0]) {
            diagnosisLabels.add(diagnosis['label']);
          }
          return diagnosisLabels.join(', ');
        } else {
          return 'No diagnosis options found';
        }
      } else {
        // print(
        //     'Failed to load response with status code: ${response.statusCode}');
        throw Exception('Failed to load response');
      }
    } catch (e) {
      // print('Error: $e');
      throw Exception('Error occurred: $e');
    }
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      // print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      try {
        String response = await query(text);

        if (mounted) {
          setState(() {
            addMessage(Message(text: DialogText(text: [response])));
          });
        }
      } catch (e) {
        // print('Error: $e');
      }
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({'message': message, 'isUserMessage': isUserMessage});
    });
  }
}

class Message {
  final DialogText text;

  Message({required this.text});
}

class DialogText {
  final List<String> text;

  DialogText({required this.text});
}

class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        var message = messages[index]['message'];
        var isUserMessage = messages[index]['isUserMessage'];
        return ListTile(
          title: isUserMessage
              ? Text(
                  message.text.text.join("\n"),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Diagnosis Options:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (message.text.text as List<String>).map((option) {
                        return ListTile(
                          title: Text(option),
                          onTap: () {
                            // Handle selection of diagnosis option
                            // For example, you can display more details about the selected option
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selected: $option'),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
