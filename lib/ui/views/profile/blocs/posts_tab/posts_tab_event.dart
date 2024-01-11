part of 'posts_tab_bloc.dart';

@immutable
sealed class PostsTabEvent extends Equatable {
  const PostsTabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsEvent extends PostsTabEvent {
  final String username;
  final int page;
  final int limit;
  final bool isQuestion;

  const LoadPostsEvent({
    required this.username,
    required this.page,
    required this.limit,
    required this.isQuestion,
  });

  @override
  List<Object?> get props => [username, page, limit, isQuestion];
}

final class PostsTabSubEvent extends PostsTabEvent {
  final ResultCount<Post> posts;

  const PostsTabSubEvent({required this.posts});

  @override
  List<Object?> get props => [posts];
}

final class ConfirmDeleteEvent extends PostsTabSubEvent {
  final Post post;

  const ConfirmDeleteEvent({
    required this.post,
    required super.posts,
  });

  @override
  List<Object?> get props => [post, posts];
}
