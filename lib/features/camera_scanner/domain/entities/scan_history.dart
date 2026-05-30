/// Model representing a scanned code snippet in history
class ScanHistory {
  final String id;
  final String scannedText;
  final String? cleanedText;
  final DateTime timestamp;
  final bool isFavorite;

  const ScanHistory({
    required this.id,
    required this.scannedText,
    this.cleanedText,
    required this.timestamp,
    this.isFavorite = false,
  });

  /// Creates a ScanHistory from a map (e.g., from SharedPreferences)
  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'] as String,
      scannedText: map['scannedText'] as String,
      cleanedText: map['cleanedText'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  /// Converts to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scannedText': scannedText,
      'cleanedText': cleanedText,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  /// CopyWith for immutable updates
  ScanHistory copyWith({
    String? id,
    String? scannedText,
    String? cleanedText,
    DateTime? timestamp,
    bool? isFavorite,
  }) {
    return ScanHistory(
      id: id ?? this.id,
      scannedText: scannedText ?? this.scannedText,
      cleanedText: cleanedText ?? this.cleanedText,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}