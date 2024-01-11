part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

final class BookmarkInitialState extends BookmarkState {}

final class BookmarkEmptyState extends BookmarkState {}

final class BookmarkPostLoadedState extends BookmarkState {
  final ResultCount<Post> posts;

  const BookmarkPostLoadedState({required this.posts});

  @override
  List<Object?> get props => [posts];
}

final class BookmarkSeriesLoadedState extends BookmarkState {
  final ResultCount<SeriesPost> seriesPost;

  const BookmarkSeriesLoadedState({required this.seriesPost});

  @override
  List<Object?> get props => [seriesPost];
}

final class BookmarkTabErrorState extends BookmarkState {
  final String message;

  const BookmarkTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class BookmarkLoadErrorState extends BookmarkState {
  final String message;

  const BookmarkLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}