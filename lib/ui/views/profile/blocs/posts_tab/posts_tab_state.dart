part of 'posts_tab_bloc.dart';

@immutable
sealed class PostsTabState extends Equatable {
  const PostsTabState();

  @override
  List<Object?> get props => [];
}

final class PostsInitialState extends PostsTabState {}

final class PostsEmptyState extends PostsTabState {}

@immutable
sealed class PostsSubState extends PostsTabState {
  final ResultCount<Post> posts;

  const PostsSubState({required this.posts});

  @override
  List<Object?> get props => [posts];
}

final class PostsLoadedState extends PostsSubState {
  const PostsLoadedState({required super.posts});
}

final class PostsDeleteSuccessState extends PostsTabState {
  final Post post;

  const PostsDeleteSuccessState({required this.post});

  @override
  List<Object?> get props => [post];
}

final class PostsTabErrorState extends PostsSubState {
  final String message;

  const PostsTabErrorState({required this.message, required super.posts});

  @override
  List<Object?> get props => [message, super.posts];
}

final class PostsLoadErrorState extends PostsTabState {
  final String message;

  const PostsLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
