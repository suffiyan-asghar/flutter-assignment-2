import 'package:http/http.dart' as http;

import '../../domain/entities/post.dart';
import '../../domain/entities/failure.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() async {
    try {
      return await remoteDataSource.getPosts();
    } on http.ClientException {
      throw const Failure('no internet connection. Please try again...');
    } catch (_) {
      throw const Failure('Something went wrong. Please try again...');
    }
  }
}