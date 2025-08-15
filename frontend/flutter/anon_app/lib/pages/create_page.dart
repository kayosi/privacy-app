import 'package:flutter/material.dart';
import '../features/post/post_controller.dart';

class CreatePage extends StatefulWidget {
  final PostController controller;

  const CreatePage({super.key, required this.controller});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController inputController = TextEditingController();
  bool isSubmitting = false;

  Future<void> submit() async {
    if (inputController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please enter something')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await widget.controller.addPost(inputController.text);
      inputController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Post submitted.')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to submit: $e')));
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: inputController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Type your truth...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isSubmitting ? null : submit,
          child: Text(isSubmitting ? "Posting..." : "Post"),
        ),
      ],
    );
  }
}
