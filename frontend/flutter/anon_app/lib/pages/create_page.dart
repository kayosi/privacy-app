import 'package:flutter/material.dart';
import '../features/post/post_controller.dart';

class CreatePage extends StatefulWidget {
  final PostController controller;
  const CreatePage({super.key, required this.controller});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController inputCtrl = TextEditingController();
  bool postAsAnon = true; // ✅ default to Anon
  String? errorMsg;

  void handleSubmit() async {
    try {
      await widget.controller.addPost(
        inputCtrl.text,
        forceAnon: postAsAnon, // ✅ pass toggle choice
      );
      inputCtrl.clear();
      setState(() {
        errorMsg = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Post submitted!")));
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: inputCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Type your truth...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Toggle for Anon / Logged-in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Post as: "),
                Switch(
                  value: postAsAnon,
                  onChanged: (val) {
                    setState(() => postAsAnon = val);
                  },
                ),
                Text(postAsAnon ? "Anon" : "Logged-in User"),
              ],
            ),

            const SizedBox(height: 12),
            ElevatedButton(onPressed: handleSubmit, child: const Text("Post")),

            if (errorMsg != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMsg!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
