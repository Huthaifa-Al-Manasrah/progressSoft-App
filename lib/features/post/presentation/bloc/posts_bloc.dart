import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:progress_soft_app/features/post/domain/use_cases/fetch_posts.dart';

import '../../../../core/utils/functions.dart';
import '../../domain/entities/post.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final FetchPostsUseCase fetchPostsUseCase;

  PostsBloc({required this.fetchPostsUseCase}) : super(PostsInitial()) {
    late List<Post> posts;
    on<PostsEvent>((event, emit) async {
      if (event is FetchPostsEvent || event is RefreshPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await fetchPostsUseCase.call();
        failureOrPosts.fold((failure) {
          emit(ErrorPostsState(message: Functions.mapFailureMessage(failure)));
        }, (data) {
          posts = data;
          emit(LoadedPostsState(posts: posts));
        });
      } else if (event is SearchPostEvent) {
        emit(LoadingPostsState());
        List<Post> searchedList = posts
            .where((post) =>
                post.title.toLowerCase().contains(event.query) ||
                post.body.toLowerCase().contains(event.query))
            .toList();
        LoadedPostsState(posts: searchedList);
      }
    });
  }
}
