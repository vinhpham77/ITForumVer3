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
  final ResultCount<PostUser> postUsers;

  const PostFollowLoadedState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class SeriesFollowLoadedState extends FollowState {
  final ResultCount<SeriesPostUser> seriesPostUsers;

  const SeriesFollowLoadedState({required this.seriesPostUsers});

  @override
  List<Object?> get props => [seriesPostUsers];
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
