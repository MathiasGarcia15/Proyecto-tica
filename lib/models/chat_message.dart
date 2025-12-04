import 'dart:convert';

class ChatMessage {
  final String author; // 'user' or 'anmi'
  final String text;

  ChatMessage({required this.author, required this.text});

  // Convert a ChatMessage into a Map
  Map<String, dynamic> toJson() => {
    'author': author,
    'text': text,
  };

  // Create a ChatMessage from a Map
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    author: json['author'],
    text: json['text'],
  );

  // Helper to encode a list of messages
  static String encode(List<ChatMessage> messages) => json.encode(
    messages
        .map<Map<String, dynamic>>((message) => message.toJson())
        .toList(),
  );

  // Helper to decode a list of messages
  static List<ChatMessage> decode(String messages) =>
      (json.decode(messages) as List<dynamic>)
          .map<ChatMessage>((item) => ChatMessage.fromJson(item))
          .toList();
}
