import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, PostState state) {
    if (state is PostInitial || state is PostLoading) {
      return const LoadingView();
    }

    if (state is PostError) {
      return ErrorView(
        message: state.message,
        onRetry: () {
          context.read<PostBloc>().add(FetchPosts());
        },
      );
    }

    if (state is PostLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<PostBloc>();
          bloc.add(RefreshPosts());
          // wait until the refresh finishes so the spinner hides
          await bloc.stream.firstWhere(
            (s) => s is PostLoaded || s is PostError,
          );
        },
        child: _buildList(state.posts),
      );
    }

    return const SizedBox();
  }

  Widget _buildList(List<Post> posts) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(
          post: post,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetailPage(post: post),
              ),
            );
          },
        );
      },
    );
  }
}
