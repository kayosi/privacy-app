import 'package:flutter/material.dart';
import '../post/post_card.dart';
import '../post/post_controller.dart';
import '../post/post_model.dart';
import '../auth/auth_controller.dart';

class PostScreen extends StatefulWidget {
  final PostController controller;
  final AuthController auth;

  const PostScreen({super.key, required this.controller, required this.auth});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController inputController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      await widget.controller.loadPosts();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Failed to load posts: $e")));
      }
    }
  }

  Future<void> submit() async {
    if (inputController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter something")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await widget.controller.addPost(inputController.text.trim());
      inputController.clear();
      await widget.controller.loadPosts();
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Post submitted.")));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Failed to submit: $e")));
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: inputController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your truth...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : submit,
              child: Text(isSubmitting ? "Posting..." : "Post"),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadPosts,
                child: ListView(
                  children: widget.controller.posts
                      .map((post) => PostCard(post: post))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
