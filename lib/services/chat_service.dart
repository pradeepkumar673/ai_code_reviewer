import '../models/chat_model.dart';

class ChatService {
  PropalChatSession? currentSession;

  Future<void> createNewSession() async {
    print("New session created");
  }

  Future<void> loadSession(String sessionId) async {
    print("Loading session: $sessionId");
  }

  Future<void> deleteSession(String sessionId) async {
    print("Deleting session: $sessionId");
  }

  List<PropalChatSession> getAllSessions() {
    return [];
  }
}
