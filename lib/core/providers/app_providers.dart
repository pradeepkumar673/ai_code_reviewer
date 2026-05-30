import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/models/persona.dart';
import 'package:devforge_ai/core/services/chat_service.dart';

/// Provider for the current AI persona
final personaProvider = StateProvider<Persona>((ref) {
  return Persona.strictProfessor;
});

/// Provider for the ChatService that updates when the persona changes
final chatServiceProvider = Provider.autoDispose<ChatService>((ref) {
  final persona = ref.watch(personaProvider);
  return ChatService(initialPersona: persona);
});