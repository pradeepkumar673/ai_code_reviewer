import '../models/chat_model.dart';

class ChatService {
  DevForgeChatSession? currentSession;   // ← Updated

  Future<void> createNewSession() async {
    print("New session created");
  }

  Future<void> loadSession(String sessionId) async {
    print("Loading session: $sessionId");
  }

  Future<void> deleteSession(String sessionId) async {
    print("Deleting session: $sessionId");
  }

  List<DevForgeChatSession> getAllSessions() {   // ← Updated
    return [];
  }
}
