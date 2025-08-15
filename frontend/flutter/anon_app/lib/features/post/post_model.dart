class PostModel {
  final int id;
  final String content;
  final bool flagged;
  final String? reason;

  PostModel({
    required this.id,
    required this.content,
    required this.flagged,
    this.reason,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      flagged: json['flagged'] ?? false,
      reason: json['reason'],
    );
  }
}
