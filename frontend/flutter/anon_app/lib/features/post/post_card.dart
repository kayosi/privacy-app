import 'package:flutter/material.dart';
import 'post_model.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: post.isFlagged ? Colors.red[900] : Colors.grey[900],
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (post.isFlagged)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '⚠️ Flagged for: ${post.reasons.join(', ')}',
                  style: TextStyle(color: Colors.yellow, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
