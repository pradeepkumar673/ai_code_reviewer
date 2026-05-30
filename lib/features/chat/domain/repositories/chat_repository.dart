import 'package:devforge_ai/features/chat/domain/entities/chat_message.dart';
import 'package:devforge_ai/features/chat/domain/entities/chat_session.dart';

abstract class ChatRepository {
  Future<void> sendMessage(String message);
  Future<List<ChatSession>> getAllSessions();
  Future<void> loadSession(String sessionId);
  Future<void> deleteSession(String sessionId);
  Future<ChatSession?> getCurrentSession();
  Future<void> createNewSession();
  Future<void> clearAllSessions();
}