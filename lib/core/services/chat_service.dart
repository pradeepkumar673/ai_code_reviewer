import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/chat_model.dart';
import '../../models/persona.dart';
import '../../repos/chat_repo.dart';
import '../../utils/constants.dart';
import 'package:uuid/uuid.dart';

/// ChatService
/// Manages the active chat session and communicates with the Gemini AI API.
class ChatService {
  DevForgeChatSession? currentSession;

  late final GenerativeModel _model;
  late ChatSession _geminiChat;

  /// Current persona - affects the system instruction and tone of the AI
  Persona _currentPersona = Persona.strictProfessor;

  ChatService({Persona initialPersona = Persona.strictProfessor}) {
    _currentPersona = initialPersona;
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_getSystemInstruction()),
    );
    _resetGeminiChat();
  }

  String _getSystemInstruction() {
    switch (_currentPersona) {
      case Persona.strictProfessor:
        return '''You are DevForge AI operating as a Strict Professor persona.
You are very detail-oriented and emphasize correctness, best practices, and theoretical foundations.
You often refer to academic sources and expect students to follow rigorous standards.
When providing code, you ensure it is well-commented, follows best practices, and is optimized for readability and performance.
You explain concepts thoroughly and expect users to understand the underlying principles.
Format code snippets with markdown code blocks.''';

      case Persona.placementGuru:
        return '''You are DevForge AI operating as a Placement Guru persona.
You focus on preparing students for technical interviews and job placements.
You prioritize practical coding problems, data structures, algorithms, and system design questions commonly asked in interviews.
You encourage users to think aloud and explain their reasoning process.
You provide hints and guidance rather than full solutions to foster learning and problem-solving skills.
You are encouraging, supportive, and focused on building confidence for interview scenarios.
Format code snippets with markdown code blocks.''';

      case Persona.startupSpeedster:
        return '''You are DevForge AI operating as a Startup Speedster persona.
You believe in rapid prototyping, getting things done quickly, and iterating based on feedback.
You favor practical, working solutions over perfect ones and encourage the use of libraries and frameworks to speed up development.
You are all about building MVPs and learning through building.
You emphasize speed, experimentation, and learning from failures in a startup environment.
Format code snippets with markdown code blocks.''';

      case Persona.openSourceSage:
        return '''You are DevForge AI operating as an Open Source Sage persona.
You value community, collaboration, transparency, and clean, maintainable code.
You advocate for following established conventions, contributing to open source projects, and leaving code better than you found it.
You are knowledgeable about licenses, documentation, and community etiquette.
You encourage users to think about the broader impact of their code and how it fits into larger ecosystems.
Format code snippets with markdown code blocks.''';

      default:
        return '''You are DevForge AI, an expert software engineering assistant.
Help developers with coding questions, debugging, code reviews, and best practices.
Format code snippets with markdown code blocks.''';
    }
  }

  void _resetGeminiChat() {
    _geminiChat = _model.startChat();
  }

  /// Update the current persona and reset the chat session to apply new instructions
  void setPersona(Persona persona) {
    if (_currentPersona == persona) return;
    _currentPersona = persona;
    _initializeModel();
    // Note: We don't reset currentSession here to preserve chat history,
    // but the new system instruction will apply to future messages.
    // If you want to clear history when changing persona, uncomment below:
    // currentSession = null;
  }

  // ── Session lifecycle ──────────────────────────────────────────────────────

  Future<void> createNewSession() async {
    currentSession = DevForgeChatSession.create();
    await SecureStorageService.saveChatSession(currentSession!);
    _resetGeminiChat(); // fresh conversation context for each session
  }

  Future<void> loadSession(String sessionId) async {
    final sessions = await SecureStorageService.getChatSessions();
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session != null) {
      currentSession = session;
      _resetGeminiChat();
      // Replay history so Gemini has context (last 20 messages max)
      final history = session.messages.take(20).toList();
      if (history.isNotEmpty) {
        _geminiChat = _model.startChat(
          history: history
              .map((m) => Content(
                    m.isFromUser ? 'user' : 'model',
                    [TextPart(m.content)],
                  ))
              .toList(),
        );
      }
    }
  }

  Future<void> deleteSession(String sessionId) async {
    await SecureStorageService.deleteChatSession(sessionId);
    if (currentSession?.id == sessionId) {
      currentSession = null;
      _resetGeminiChat();
    }
  }

  /// Returns all stored sessions (newest first).
  Future<List<DevForgeChatSession>> getAllSessions() async {
    final sessions = await SecureStorageService.getChatSessions();
    return sessions.reversed.toList();
  }

  // ── Messaging ────────────────────────────────────────────────────────────

  /// Sends [message] to Gemini, appends both the user message and the AI
  /// response to [currentSession], and persists the session.
  ///
  /// Creates a new session automatically if none is active.
  Future<void> sendMessage(String message) async {
    // Auto-create a session on first message
    if (currentSession == null) {
      await createNewSession();
    }

    // Append user message
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      content: message,
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    currentSession = currentSession!.copyWith(
      messages: [...currentSession!.messages, userMsg],
      // Use the first user message as the session title
      title: currentSession!.messages.isEmpty ? _trimTitle(message) : currentSession!.title,
    );

    await SecureStorageService.saveChatSession(currentSession!);

    // Call Gemini
    try {
      final response = await _geminiChat.sendMessage(Content.text(message));
      final responseText =
          response.text ?? 'Sorry, I could not generate a response.';

      final aiMsg = ChatMessage(
        id: const Uuid().v4(),
        content: responseText,
        isFromUser: false,
        timestamp: DateTime.now(),
      );

      currentSession = currentSession!.copyWith(
        messages: [...currentSession!.messages, aiMsg],
      );

      await SecureStorageService.saveChatSession(currentSession!);
    } catch (e) {
      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        content: '⚠️ Error: ${e.toString()}',
        isFromUser: false,
        timestamp: DateTime.now(),
      );

      currentSession = currentSession!.copyWith(
        messages: [...currentSession!.messages, errorMsg],
      );

      await SecureStorageService.saveChatSession(currentSession!);
      rethrow; // Let the UI know something went wrong
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  String _trimTitle(String message) {
    const maxLen = 40;
    final trimmed = message.trim().replaceAll('\n', ' ');
    return trimmed.length <= maxLen ? trimmed : '${trimmed.substring(0, maxLen)}…';
  }
}