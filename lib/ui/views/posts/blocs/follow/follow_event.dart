part of 'follow_bloc.dart';

@immutable
sealed class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsFollowEvent extends FollowEvent {
  final int page;
  final int limit;
  final String tag;

  const LoadPostsFollowEvent({
    required this.page,
    required this.limit,
    this.tag = ""
  });

  @override
  List<Object?> get props => [page, limit, tag];
}

final class LoadSeriesFollowEvent extends FollowEvent {
  final int page;
  final int limit;

  const LoadSeriesFollowEvent({
    required this.page,
    required this.limit
  });

  @override
  List<Object?> get props => [page, limit];
}