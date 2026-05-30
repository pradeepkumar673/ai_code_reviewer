import 'package:devforge_ai/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Use case for sending a message to the AI chat
class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  /// Send a message and get AI response
  Future<void> call(String message) async {
    await repository.sendMessage(message);
  }
}

/// Riverpod provider for the SendMessage use case
final sendMessageProvider = Provider<SendMessage>((ref) {
  // TODO: Replace with proper DI when repository is available
  // For now, we'll need to create a simple implementation
  return SendMessage(ChatRepositoryImpl());
});

// Placeholder for the chat repository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});