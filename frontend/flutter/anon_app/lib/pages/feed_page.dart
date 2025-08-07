import 'package:flutter/material.dart';
import '../features/post/post_card.dart';
import '../features/post/post_controller.dart';
import '../features/post/post_model.dart';

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
    widget.controller.loadPosts().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.controller.posts
          .map((post) => PostCard(post: post))
          .toList(),
    );
  }
}
