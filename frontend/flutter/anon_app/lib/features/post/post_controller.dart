import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_model.dart';

class PostController {
  final List<Post> _posts = [];
  final List<String> _flaggedWords = ['kill', 'suicide', 'bomb', 'abuse'];

  List<Post> get posts => _posts;

  Future<void> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('posts') ?? [];
    _posts.clear();
    _posts.addAll(jsonList.map((j) => Post.fromJson(jsonDecode(j))));
  }

  Future<void> savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _posts.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('posts', jsonList);
  }

  void addPost(String content) {
    if (content.trim().isEmpty) return;

    final lower = content.toLowerCase();
    final reasons = _flaggedWords.where((w) => lower.contains(w)).toList();
    final flagged = reasons.isNotEmpty;

    final post = Post(content: content, isFlagged: flagged, reasons: reasons);
    _posts.insert(0, post);
    savePosts(); // save after insert
  }
}
