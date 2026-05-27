class ChatMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
  });
}

class PropalChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  PropalChatSession({
    required this.id,
    required this.title,
    required this.messages,
  });
}
