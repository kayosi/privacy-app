class Post {
  final String content;
  final DateTime timestamp;
  final bool isFlagged;
  final List<String> reasons;

  Post({
    required this.content,
    DateTime? timestamp,
    this.isFlagged = false,
    this.reasons = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isFlagged': isFlagged,
    'reasons': reasons,
  };

  static Post fromJson(Map<String, dynamic> json) => Post(
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isFlagged: json['isFlagged'],
    reasons: List<String>.from(json['reasons']),
  );
}
