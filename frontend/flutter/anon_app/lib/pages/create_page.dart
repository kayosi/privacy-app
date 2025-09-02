import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/post/post_controller.dart';

class CreatePage extends StatefulWidget {
  final PostController controller;
  const CreatePage({super.key, required this.controller});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _text = TextEditingController();
  bool _forceAnon = false;
  bool _submitting = false;

  Future<void> _submit() async {
    if (_text.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await widget.controller.addPost(_text.text.trim(), forceAnon: _forceAnon);
      await widget.controller.loadPosts(); // ensure feed is fresh
      if (mounted) context.go('/feed');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to post: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _text,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: "Type your truth…",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text("Post as Anonymous"),
          value: _forceAnon,
          onChanged: (v) => setState(() => _forceAnon = v),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          child: Text(_submitting ? "Posting…" : "Post"),
        ),
      ],
    );
  }
}
