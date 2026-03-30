// import 'dart:convert';
// import 'dart:isolate';
//
// import 'package:http/http.dart' as http;
//
// class Post {
//   final int id;
//   final String title;
//   final String body;
//
//   Post({required this.id, required this.title, required this.body});
//
//   // Factory constructor
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? "No Title",
//       body: json['body'] ?? "No Body",
//     );
//   }
// }
//
// Future<List<Post>> parsePostsInIsolate(String jsonString) async {
//   final p = ReceivePort();
//   await Isolate.spawn(_parse, [p.sendPort, jsonString]);
//   return await p.first as List<Post>;
// }
//
// void _parse(List<dynamic> args) {
//   SendPort sendPort = args[0];
//   String jsonString = args[1];
//   final data = json.decode(jsonString) as List<dynamic>;
//   final posts = data.map((e) => Post.fromJson(e)).toList();
//   sendPort.send(posts);
// }
//
// Future<List<Post>> fetchPosts() async {
//   final response = await http.get(
//     Uri.parse("https://jsonplaceholder.typicode.com/posts"),
//     headers: {"User-Agent": "FlutterApp", "Accept": "application/json"},
//   );
//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     return await parsePostsInIsolate(response.body);
//   } else {
//     throw Exception("Failed to load posts");
//   }
// }
//
// Stream<int> counterStream(int max) async* {
//   for (int i = 1; i <= max; i++) {
//     await Future.delayed(Duration(seconds: 1));
//     yield i;
//   }
// }
//
// import 'dart:convert';
// import 'dart:isolate';
//
// import 'package:http/http.dart' as http;
//
// class Post {
//   final int id;
//   final String title;
//   final String body;
//
//   Post({required this.id, required this.title, required this.body});
//
//   // Factory constructor
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? "No Title",
//       body: json['body'] ?? "No Body",
//     );
//   }
// }
//
// Future<List<Post>> parsePostsInIsolate(String jsonString) async {
//   final p = ReceivePort();
//   await Isolate.spawn(_parse, [p.sendPort, jsonString]);
//   return await p.first as List<Post>;
// }
//
// void _parse(List<dynamic> args) {
//   SendPort sendPort = args[0];
//   String jsonString = args[1];
//   final data = json.decode(jsonString) as List<dynamic>;
//   final posts = data.map((e) => Post.fromJson(e)).toList();
//   sendPort.send(posts);
// }
//
// Future<List<Post>> fetchPosts() async {
//   final response = await http.get(
//     Uri.parse("https://jsonplaceholder.typicode.com/posts"),
//     headers: {"User-Agent": "FlutterApp", "Accept": "application/json"},
//   );
//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     return await parsePostsInIsolate(response.body);
//   } else {
//     throw Exception("Failed to load posts");
//   }
// }
//
// Stream<int> counterStream(int max) async* {
//   for (int i = 1; i <= max; i++) {
//     await Future.delayed(Duration(seconds: 1));
//     yield i;
//   }
// }
