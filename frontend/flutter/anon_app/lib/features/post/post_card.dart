import 'package:flutter/material.dart';
import 'post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "Posted by: ${post.user}",
              style: TextStyle(
                fontSize: 12,
                color: post.user == "anon" ? Colors.grey : Colors.green,
              ),
            ),
            if (post.flagged)
              Text(
                "⚠️ Flagged: ${post.reason}",
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
