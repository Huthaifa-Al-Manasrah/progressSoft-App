part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FetchPostsEvent extends PostsEvent {}

class RefreshPostsEvent extends PostsEvent {}

class SearchPostEvent extends PostsEvent {
  final String query;

  SearchPostEvent({required this.query});
}
