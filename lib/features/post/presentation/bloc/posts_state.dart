part of 'posts_bloc.dart';

@immutable
abstract class PostsState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class LoadingPostsState extends PostsState {}

class LoadedPostsState extends PostsState {
  final List<Post> posts;

  LoadedPostsState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class ErrorPostsState extends PostsState {
  final String message;
  ErrorPostsState({required this.message});
}

