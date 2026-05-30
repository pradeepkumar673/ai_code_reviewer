import 'package:devforge_ai/core/services/chat_service.dart';
import 'package:devforge_ai/features/chat/domain/entities/chat_message.dart';
import 'package:devforge_ai/features/chat/domain/entities/chat_session.dart';
import 'package:devforge_ai/features/chat/domain/repositories/chat_repository.dart';

/// Implementation of the ChatRepository that uses the existing ChatService
class ChatRepositoryImpl implements ChatRepository {
  final ChatService _chatService;

  ChatRepositoryImpl(this._chatService);

  @override
  Future<void> sendMessage(String message) async {
    await _chatService.sendMessage(message);
  }

  @override
  Future<List<ChatSession>> getAllSessions() async {
    final sessions = await _chatService.getAllSessions();
    // Convert from DevForgeChatSession to ChatSession
    return sessions.map((session) => ChatSession(
      id: session.id,
      title: session.title,
      messages: session.messages.map((msg) => ChatMessage(
        id: msg.id,
        content: msg.content,
        isFromUser: msg.isFromUser,
        timestamp: msg.timestamp,
      )).toList(),
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
    )).toList();
  }

  @override
  Future<void> loadSession(String sessionId) async {
    await _chatService.loadSession(sessionId);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _chatService.deleteSession(sessionId);
  }

  @override
  Future<ChatSession?> getCurrentSession() async {
    if (_chatService.currentSession == null) return null;

    final session = _chatService.currentSession!;
    return ChatSession(
      id: session.id,
      title: session.title,
      messages: session.messages.map((msg) => ChatMessage(
        id: msg.id,
        content: msg.content,
        isFromUser: msg.isFromUser,
        timestamp: msg.timestamp,
      )).toList(),
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
    );
  }

  @override
  Future<void> createNewSession() async {
    await _chatService.createNewSession();
  }

  @override
  Future<void> clearAllSessions() async {
    // This would need to be added to ChatService
    // For now, we'll just delete all sessions from storage
    final sessions = await _chatService.getAllSessions();
    for (final session in sessions) {
      await _chatService.deleteSession(session.id);
    }
  }
}