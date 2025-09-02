import 'package:flutter/material.dart';
import '../features/post/post_controller.dart';
import '../features/post/post_model.dart';

class FeedPage extends StatefulWidget {
  final PostController controller;
  const FeedPage({super.key, required this.controller});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    widget.controller
        .loadPosts()
        .then((_) {
          if (mounted) setState(() => _loading = false);
        })
        .catchError((_) {
          if (mounted) setState(() => _loading = false);
        });
  }

  Future<void> _refresh() async {
    await widget.controller.loadPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final List<PostModel> posts = widget.controller.posts;
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: const [
            SizedBox(height: 200),
            Center(child: Text("No posts yet.")),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, i) {
          final p = posts[i];
          return ListTile(
            title: Text(p.content),
            subtitle: Text(
              p.flagged
                  ? "⚠️ Flagged: ${p.reason ?? ''}"
                  : (p.author != null ? "by ${p.author}" : "Anonymous"),
            ),
          );
        },
      ),
    );
  }
}
