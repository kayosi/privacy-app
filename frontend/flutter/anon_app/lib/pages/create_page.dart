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

  void submit() {
    widget.controller.addPost(inputController.text);
    inputController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ Post submitted.')));
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
        ElevatedButton(onPressed: submit, child: const Text("Post")),
      ],
    );
  }
}
