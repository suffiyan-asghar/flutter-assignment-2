import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post_model.dart';

class PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSource(this.client);

  Future<List<PostModel>> getPosts() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}