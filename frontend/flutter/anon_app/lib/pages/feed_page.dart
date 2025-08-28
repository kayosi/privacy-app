import 'package:flutter/material.dart';
import '../features/post/post_controller.dart';

class FeedPage extends StatefulWidget {
  final PostController controller;
  const FeedPage({super.key, required this.controller});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadPosts().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.controller.posts;

    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: posts.isEmpty
          ? const Center(child: Text("No posts yet"))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "by ${post.user}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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
              },
            ),
    );
  }
}
