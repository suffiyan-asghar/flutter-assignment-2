import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/usecases/get_posts.dart';
import 'presentation/bloc/post_bloc.dart';
import 'presentation/bloc/post_event.dart';
import 'presentation/pages/posts_page.dart';

void main() {
  final dataSource = PostRemoteDataSource(http.Client());
  final repository = PostRepositoryImpl(dataSource);
  final getPosts = GetPosts(repository);

  runApp(MyApp(getPosts: getPosts));
}

class MyApp extends StatelessWidget {
  final GetPosts getPosts;

  const MyApp({super.key, required this.getPosts});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.indigo.withValues(alpha: 0.12)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => PostBloc(getPosts)..add(FetchPosts()),
        child: const PostsPage(),
      ),
    );
  }
}