import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post_model.dart';

class PostController {
  List<PostModel> posts = [];
  final String baseUrl =
      "http://192.168.100.49:8080"; // Android emulator loopback
  // For real phone testing via USB, replace with your PC's LAN IP (e.g., http://192.168.1.5:8080)

  Future<void> loadPosts() async {
    final response = await http.get(Uri.parse("$baseUrl/posts"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      posts = data.map((item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<void> addPost(String content) async {
    final response = await http.post(
      Uri.parse("$baseUrl/posts"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"content": content}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      posts.add(PostModel.fromJson(data));
    } else {
      throw Exception("Failed to create post");
    }
  }
}
