class PostModel {
  final int id;
  final String content;
  final bool flagged;
  final String? reason;
  final String? author; // null => Anonymous

  PostModel({
    required this.id,
    required this.content,
    required this.flagged,
    this.reason,
    this.author,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      content: json['content'] as String,
      flagged: (json['flagged'] as bool?) ?? false,
      reason: json['reason'] as String?,
      author: json['author'] as String?,
    );
  }
}
