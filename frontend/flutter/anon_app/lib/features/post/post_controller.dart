import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_controller.dart';
import 'post_model.dart';

class PostController {
  List<PostModel> posts = [];
  final String baseUrl = "http://192.168.100.52:8080"; // ⚡ your LAN IP
  final AuthController auth;

  PostController(this.auth);

  Future<void> loadPosts() async {
    final response = await http.get(Uri.parse("$baseUrl/posts"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      posts = data.map((item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<void> addPost(String content, {bool forceAnon = false}) async {
    final headers = {"Content-Type": "application/json"};

    // ✅ Only attach token if not forcing Anon and user is logged in
    if (!forceAnon && auth.token != null) {
      headers["Authorization"] = "Bearer ${auth.token!}";
    }

    final response = await http.post(
      Uri.parse("$baseUrl/posts"),
      headers: headers,
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
