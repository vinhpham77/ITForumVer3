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
  final ResultCount<PostUser> postUsers;

  const PostLoadedState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class SeriesLoadedState extends SearchState {
  final ResultCount<SeriesPostUser> seriesPostUsers;

  const SeriesLoadedState({required this.seriesPostUsers});

  @override
  List<Object?> get props => [seriesPostUsers];
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