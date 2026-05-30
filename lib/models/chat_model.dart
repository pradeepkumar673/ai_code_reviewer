import 'package:uuid/uuid.dart';

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'isFromUser': isFromUser,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        content: json['content'] as String,
        isFromUser: json['isFromUser'] as bool,
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}

class DevForgeChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  DevForgeChatSession({
    required this.id,
    required this.title,
    required this.messages,
  });

  /// Creates a brand-new empty session with a generated id.
  factory DevForgeChatSession.create({String title = 'New Chat'}) {
    return DevForgeChatSession(
      id: const Uuid().v4(),
      title: title,
      messages: [],
    );
  }

  DevForgeChatSession copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
  }) =>
      DevForgeChatSession(
        id: id ?? this.id,
        title: title ?? this.title,
        messages: messages ?? this.messages,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory DevForgeChatSession.fromJson(Map<String, dynamic> json) =>
      DevForgeChatSession(
        id: json['id'] as String,
        title: json['title'] as String,
        messages: (json['messages'] as List<dynamic>)
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
}

// Kept for backward-compatibility — remove once all references are updated
typedef PropalChatSession = DevForgeChatSession;
