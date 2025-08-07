import 'package:flutter/material.dart';
import '../post/post_card.dart';
import '../post/post_controller.dart';
import '../post/post_model.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostController controller = PostController();
  final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadPosts().then((_) => setState(() {}));
  }

  void submit() {
    controller.addPost(inputController.text);
    inputController.clear();
    setState(() {});
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your truth...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
            ),
            ElevatedButton(onPressed: submit, child: const Text("Post")),
            Expanded(
              child: ListView(
                children: controller.posts
                    .map((post) => PostCard(post: post))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
