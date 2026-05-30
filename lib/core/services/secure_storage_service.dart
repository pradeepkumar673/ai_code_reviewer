import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';

/// SecureStorageService
/// Handles secure storage of user data and chat sessions using flutter_secure_storage.
class SecureStorageService {
  static final _storage = const FlutterSecureStorage();

  // ── User ────────────────────────────────────────────────────────────────
  static const _userKey = 'devforge_ai_user';

  static Future<void> saveUser(User user) async {
    final json = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: json);
  }

  static Future<User?> getCurrentUser() async {
    final json = await _storage.read(key: _userKey);
    if (json == null) return null;
    final map = jsonDecode(json) as Map<String, dynamic>;
    return User.fromJson(map);
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  // ── Chat Sessions ───────────────────────────────────────────────────────
  static const _sessionsKey = 'devforge_ai_chat_sessions';

  static Future<void> saveChatSession(DevForgeChatSession session) async {
    final sessions = await getChatSessions();
    // Remove existing session with same id if any
    sessions.removeWhere((s) => s.id == session.id);
    sessions.add(session);
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // newest first
    final json = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _storage.write(key: _sessionsKey, value: json);
  }

  static Future<List<DevForgeChatSession>> getChatSessions() async {
    final json = await _storage.read(key: _sessionsKey);
    if (json == null) return [];
    final List<dynamic> list = jsonDecode(json);
    return list.map((e) => DevForgeChatSession.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> deleteChatSession(String sessionId) async {
    final sessions = await getChatSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    final json = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _storage.write(key: _sessionsKey, value: json);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

// ── Chat Session Model ──────────────────────────────────────────────────────
class DevForgeChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  DateTime updatedAt;

  DevForgeChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DevForgeChatSession.create() {
    final now = DateTime.now();
    return DevForgeChatSession(
      id: const Uuid().v4(),
      title: 'New Chat',
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  DevForgeChatSession copyWith({
    String? title,
    List<ChatMessage>? messages,
    DateTime? updatedAt,
  }) {
    return DevForgeChatSession(
      id: id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DevForgeChatSession.fromJson(Map<String, dynamic> json) {
    return DevForgeChatSession(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}