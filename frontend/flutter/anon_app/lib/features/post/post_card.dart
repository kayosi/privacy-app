import 'package:flutter/material.dart';
import 'post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: post.flagged ? Colors.red[900] : Colors.grey[900],
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (post.flagged)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '⚠️ Flagged for: ${post.reason ?? 'No reason provided'}',
                  style: const TextStyle(color: Colors.yellow, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
