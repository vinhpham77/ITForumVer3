part of 'search_bloc.dart';

@immutable
sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

final class FollowInitialState extends SearchState {}

final class FollowEmptyState extends SearchState {}

final class PostLoadedState extends SearchState {
  final ResultCount<Post> posts;

  const PostLoadedState({required this.posts});

  @override
  List<Object?> get props => [posts];
}

final class SeriesLoadedState extends SearchState {
  final ResultCount<SeriesPost> seriesPost;

  const SeriesLoadedState({required this.seriesPost});

  @override
  List<Object?> get props => [seriesPost];
}

final class FollowTabErrorState extends SearchState {
  final String message;

  const FollowTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class FollowLoadErrorState extends SearchState {
  final String message;

  const FollowLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}