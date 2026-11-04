import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/failure.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;

  PostBloc(this.getPosts) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<RefreshPosts>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
    FetchPosts event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    await _loadPosts(emit);
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<PostState> emit,
  ) async {
    await _loadPosts(emit);
  }

  Future<void> _loadPosts(Emitter<PostState> emit) async {
    try {
      final posts = await getPosts();
      emit(PostLoaded(posts));
    } on Failure catch (failure) {
      emit(PostError(failure.message));
    }
  }
}