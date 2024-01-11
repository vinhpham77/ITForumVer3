part of 'follows_tab_bloc.dart';

@immutable
sealed class FollowsTabEvent extends Equatable {
  const FollowsTabEvent();

  @override
  List<Object> get props => [];
}

@immutable
sealed class FollowsSubEvent extends FollowsTabEvent {
  final ResultCount<UserStats> userStatsList;

  const FollowsSubEvent({required this.userStatsList});

  @override
  List<Object> get props => [userStatsList];
}

final class LoadFollowsEvent extends FollowsTabEvent {
  final String username;
  final int page;
  final int size;
  final bool isFollowed;

  const LoadFollowsEvent({
    required this.username,
    required this.page,
    required this.size,
    required this.isFollowed,
  });

  @override
  List<Object> get props => [username, page, size, isFollowed];
}

final class LoadFollowsErrorEvent extends FollowsTabEvent {
  final String message;

  const LoadFollowsErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}
