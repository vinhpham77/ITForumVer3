import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/jwt_payload.dart';
import 'package:it_forum/repositories/user_repository.dart';

import '../../../../../dtos/ContentStats.dart';
import '../../../../../dtos/bookmark_item.dart';
import '../../../../../dtos/follow_stats.dart';
import '../../../../../dtos/post_user.dart';
import '../../../../../dtos/profile_stats.dart';
import '../../../../../dtos/tag_count.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/content_repository.dart';
import '../../../../../repositories/follow_repository.dart';
import '../../../../../repositories/tag_repository.dart';
import '../../../../common/utils/common_utils.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final FollowRepository _followRepository;
  final TagRepository _tagRepository;
  final ContentRepository _contentRepository;

  ProfileBloc({
    required UserRepository userRepository,
    required TagRepository tagRepository,
    required FollowRepository followRepository,
    required ContentRepository contentRepository,
  })  : _userRepository = userRepository,
        _tagRepository = tagRepository,
        _followRepository = followRepository,
        _contentRepository = contentRepository,
        super(ProfileInitialState()) {
    on<LoadProfileEvent>(_loadProfile);
    on<FollowEvent>(_follow);
    on<UnfollowEvent>(_unfollow);
    on<SuccessFollowItemEvent>(_followItem);
    on<SuccessUnfollowItemEvent>(_unfollowItem);
    on<DecreaseSeriesCountEvent>(_decreaseSeriesCount);
    on<DecreasePostsCountEvent>(_decreasePostsCount);
  }

  Future<void> _loadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      final userFuture = _userRepository.get(event.username);
      final isFollowingFuture =
          JwtPayload.sub != null && JwtPayload.sub != event.username
              ? _followRepository.isFollowing(event.username)
              : Future.value(false);

      bool isFollowing = false;
      final responses = await Future.wait([userFuture, isFollowingFuture]);
      Response<dynamic> userResponse = responses[0] as Response<dynamic>;
      User user = User.fromJson(userResponse.data);

      if (responses[1] is Response<dynamic>) {
        var isFollowingResponse = responses[1] as Response<dynamic>;
        isFollowing = isFollowingResponse.data;
      }

      emit(ProfileLoadedState(
          user: user,
          isFollowing: isFollowing,
          tagCounts: const [],
          profileStats: null));

      var followStatsFuture = _followRepository.getStats(event.username);
      var contentStatsFuture = _contentRepository.getStats(event.username);
      var tagCountsFuture = _tagRepository.getTagCounts(event.username);
      final statResponses = await Future.wait(
          [followStatsFuture, contentStatsFuture, tagCountsFuture]);

      Response<dynamic> followStatsResponse = statResponses[0];
      Response<dynamic> contentStatsResponse = statResponses[1];
      Response<dynamic> tagCountsResponse = statResponses[2];

      List<TagCount> tagCounts = tagCountsResponse.data
          .map<TagCount>((dynamic item) => TagCount.fromJson(item))
          .toList();

      FollowStats followStats = FollowStats.fromJson(followStatsResponse.data);
      ContentStats contentStats =
          ContentStats.fromJson(contentStatsResponse.data);

      ProfileStats profileStats = ProfileStats(
          followerCount: followStats.followerCount,
          followingCount: followStats.followingCount,
          postCount: contentStats.postCount,
          seriesCount: contentStats.seriesCount,
          questionCount: contentStats.questionCount);

      emit(ProfileAllLoadedState(
          user: user,
          isFollowing: isFollowing,
          tagCounts: tagCounts,
          profileStats: profileStats));
    } catch (error) {
      if (error is DioException &&
          error.response != null &&
          error.response!.statusCode == 404) {
        emit(ProfileNotFoundState(
            message: 'Không tìm thấy người dùng @${event.username}!'));
        return;
      }

      String message = getMessageFromException(error);
      emit(ProfileLoadErrorState(message: message));
    }
  }

  Future<void> _follow(FollowEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileFollowWaitingState(
          user: event.user,
          isFollowing: event.isFollowing,
          tagCounts: event.tagCounts,
          profileStats: event.profileStats));

      await _followRepository.follow(event.user.username);

      event.profileStats?.followerCount++;
      emit(ProfileFollowedState(
          user: event.user,
          isFollowing: true,
          tagCounts: event.tagCounts,
          profileStats: event.profileStats));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(ProfileCommonErrorState(
          user: event.user,
          isFollowing: event.isFollowing,
          message: message,
          tagCounts: event.tagCounts,
          profileStats: event.profileStats));
    }
  }

  Future<void> _unfollow(
      UnfollowEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileFollowWaitingState(
          user: event.user,
          isFollowing: event.isFollowing,
          tagCounts: event.tagCounts,
          profileStats: event.profileStats));

      await _followRepository.unfollow(event.user.username);

      event.profileStats?.followerCount--;
      emit(ProfileUnfollowedState(
          user: event.user,
          isFollowing: false,
          tagCounts: event.tagCounts,
          profileStats: event.profileStats));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(ProfileCommonErrorState(
          user: event.user,
          isFollowing: event.isFollowing,
          message: message,
          tagCounts: event.tagCounts,
          profileStats: event.profileStats));
    }
  }

  void _followItem(SuccessFollowItemEvent event, Emitter<ProfileState> emit) {
    event.profileStats?.followingCount++;

    emit(ProfileItemFollowedState(
        user: event.user,
        isFollowing: true,
        tagCounts: event.tagCounts,
        profileStats: event.profileStats));
  }

  void _unfollowItem(
      SuccessUnfollowItemEvent event, Emitter<ProfileState> emit) {
    event.profileStats?.followingCount--;

    emit(ProfileItemUnfollowedState(
        user: event.user,
        isFollowing: false,
        tagCounts: event.tagCounts,
        profileStats: event.profileStats));
  }

  void _decreaseSeriesCount(
      DecreaseSeriesCountEvent event, Emitter<ProfileState> emit) {
    event.profileStats?.seriesCount--;

    emit(SeriesCountDecreasedState(
        user: event.user,
        isFollowing: event.isFollowing,
        tagCounts: event.tagCounts,
        profileStats: event.profileStats));
  }

  Future<void> _decreasePostsCount(
      DecreasePostsCountEvent event, Emitter<ProfileState> emit) async {
    event.profileStats?.postCount--;

    var tags = event.postUser.post.tags.map((e) => e.name);
    String questionTag =
        tags.firstWhere((element) => element == 'HoiDap', orElse: () {
      return '';
    });

    if (questionTag.isNotEmpty) {
      event.profileStats?.questionCount--;
    }

    var tagCounts = event.tagCounts.map((e) {
      if (tags.contains(e.tag)) {
        return TagCount(tag: e.tag, count: e.count - 1);
      }

      return e;
    }).toList();

    emit(PostsCountDecreasedState(
        user: event.user.copyWith(),
        isFollowing: event.isFollowing,
        tagCounts: tagCounts,
        profileStats: event.profileStats));
  }
}
