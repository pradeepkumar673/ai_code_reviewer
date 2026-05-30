import 'package:devforge_ai/features/chat/domain/entities/persona.dart';

/// Represents a single message in a chat conversation
class ChatMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final Persona? personaUsed; // Which persona was used for this message (if AI)

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.personaUsed,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isFromUser: json['isFromUser'] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      personaUsed: json['personaUsed'] != null
          ? Persona.values.firstWhere(
              (e) => e.displayName == json['personaUsed'],
              orElse: () => Persona.strictProfessor,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'personaUsed': personaUsed?.displayName,
    };
  }
}