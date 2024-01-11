part of 'follow_bloc.dart';

@immutable
sealed class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object?> get props => [];
}

final class FollowInitialState extends FollowState {}

final class FollowEmptyState extends FollowState {}

final class PostFollowLoadedState extends FollowState {
  final ResultCount<Post> posts;

  const PostFollowLoadedState({required this.posts});

  @override
  List<Object?> get props => [posts];
}

final class SeriesFollowLoadedState extends FollowState {
  final ResultCount<SeriesPost> seriesPost;

  const SeriesFollowLoadedState({required this.seriesPost});

  @override
  List<Object?> get props => [seriesPost];
}

final class FollowTabErrorState extends FollowState {
  final String message;

  const FollowTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class FollowLoadErrorState extends FollowState {
  final String message;

  const FollowLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}