import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/jwt_payload.dart';
import 'package:it_forum/ui/common/app_constants.dart';
import 'package:it_forum/ui/views/profile/blocs/profile/profile_bloc.dart';
import 'package:it_forum/ui/views/profile/widgets/count_stats.dart';
import 'package:it_forum/ui/views/profile/widgets/custom_tab.dart';
import 'package:it_forum/ui/views/profile/widgets/follows_tab/follows_tab.dart';
import 'package:it_forum/ui/views/profile/widgets/personal_tab/personal_tab.dart';
import 'package:it_forum/ui/views/profile/widgets/posts_tab/posts_tab.dart';
import 'package:it_forum/ui/views/profile/widgets/series_tab/series_tab.dart';
import 'package:it_forum/ui/views/profile/widgets/tag_chart.dart';
import 'package:it_forum/ui/widgets/user_avatar.dart';

import '../../../dtos/notify_type.dart';
import '../../router.dart';
import '../../widgets/notification.dart';
import 'blocs/profile/profile_provider.dart';

const int _left = 5;
const int _right = 2;

class Profile extends StatelessWidget {
  final String username;
  final int selectedIndex;
  final Map<String, dynamic> params;

  const Profile(
      {super.key,
      required this.username,
      required this.selectedIndex,
      required this.params});

  int get page => params['page'] ?? 1;

  bool get isPostBookmarks => params['postBookmarks'] != 0;

  int get size => params['size'] ?? pageSize;

  @override
  Widget build(BuildContext context) {
    return ProfileBlocProvider(
      username: username,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileNotFoundState) {
            appRouter.go('not-found');
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          } else if (state is ProfileCommonErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSubState) {
              final tabs = getTabStates();
              return Container(
                color: Colors.white.withOpacity(0.5),
                padding:
                    const EdgeInsets.symmetric(vertical: bodyVerticalSpace),
                child: Column(
                  children: [
                    _buildUserContainer(context, state),
                    buildTabBar(tabs),
                    Container(
                      constraints: const BoxConstraints(maxWidth: maxContent),
                      margin: const EdgeInsets.symmetric(
                          horizontal: horizontalSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTabView(tabs),
                          _buildAnalysisView(state)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoadErrorState) {
              return const Center(
                  child: Text('Có lỗi xảy ra. Vui lòng thử lại sau!',
                      style: TextStyle(color: Colors.red, fontSize: 20)));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildAnalysisView(ProfileState state) {
    if (state is ProfileLoadedState) {
      return Expanded(
        flex: _right,
        child: Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: const Center(
              child: CircularProgressIndicator(),
            )),
      );
    } else if (state is ProfileSubState) {
      return Expanded(
        flex: _right,
        child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CountStats(profileStats: state.profileStats!),
                TagChart(tagCounts: state.tagCounts),
              ],
            )),
      );
    }

    return Expanded(
        flex: _right,
        child: Container(
            padding: const EdgeInsets.only(top: 16.0),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.black12,
                ),
              ),
            )));
  }

  Expanded _buildTabView(List<Map<String, dynamic>> tabs) {
    return Expanded(
      flex: _left,
      child: Container(
        transform: Matrix4.translationValues(-8.0, 0, 0),
        padding: const EdgeInsets.only(right: 20.0),
        child: buildTab(selectedIndex),
      ),
    );
  }

  Container buildTabBar(List<Map<String, dynamic>> tabs) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: horizontalSpace),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
          top: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxContent),
          child: Row(
            children: [
              Expanded(
                flex: _left,
                child: Container(
                  transform: Matrix4.translationValues(-20.0, 0, 0),
                  child: Row(
                    children: [
                      for (int index = 0; index < tabs.length; index++)
                        CustomTab(
                          isActive: index == selectedIndex,
                          onTap: () => appRouter
                              .go(tabs[index]['path']!, extra: {'size': size}),
                          label: '${tabs[index]['title']}',
                        ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: _right,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildUserContainer(BuildContext context, ProfileSubState state) {
    return Container(
      constraints: const BoxConstraints(maxWidth: maxContent),
      margin: const EdgeInsets.symmetric(horizontal: horizontalSpace),
      child: Row(
        children: [
          Row(
            children: [
              ClipOval(
                  child: UserAvatar(
                imageUrl: state.user.avatarUrl,
                size: 68,
              )),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.displayName,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '@${state.user.username}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (state.user.username != JwtPayload.sub)
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 40),
              child: _buildFollowButtonStack(context, state),
            ),
        ],
      ),
    );
  }

  Widget _buildFollowButtonStack(BuildContext context, ProfileSubState state) {
    bool isWaiting = state is ProfileFollowWaitingState;

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildFollowButton(context, state, isWaiting),
        if (isWaiting)
          const SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildFollowButton(
      BuildContext context, ProfileSubState state, bool isWaiting) {
    if (state.isFollowing) {
      return TextButton(
        onPressed: isWaiting
            ? null
            : () => context.read<ProfileBloc>().add(UnfollowEvent(
                user: state.user,
                isFollowing: state.isFollowing,
                tagCounts: state.tagCounts,
                profileStats: state.profileStats)),
        style: TextButton.styleFrom(
          backgroundColor: Colors.indigoAccent.withOpacity(0.05),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        ),
        child: const Text('Đang theo dõi'),
      );
    }

    return OutlinedButton(
        onPressed: isWaiting
            ? null
            : () => context.read<ProfileBloc>().add(FollowEvent(
                user: state.user,
                isFollowing: state.isFollowing,
                tagCounts: state.tagCounts,
                profileStats: state.profileStats)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        ),
        child: const Text('Theo dõi'));
  }

  handleTabChange(int index, List<Map<String, dynamic>> tabs) {
    appRouter.go(tabs[index]['path']!, extra: {'page': 1, 'size': size});
  }

  List<Map<String, dynamic>> getTabStates() {
    return [
      {
        'title': 'Bài viết',
        'path': '/profile/$username/posts',
      },
      {
        'title': 'Câu hỏi',
        'path': '/profile/$username/questions',
      },
      {
        'title': 'Series',
        'path': '/profile/$username/series',
      },
      {
        'title': 'Bookmark',
        'path': isPostBookmarks
            ? '/profile/$username/bookmarks/posts'
            : '/profile/$username/bookmarks/series',
      },
      {
        'title': 'Đang theo dõi',
        'path': '/profile/$username/followings',
      },
      {
        'title': 'Người theo dõi',
        'path': '/profile/$username/followers',
      },
      {
        'title': 'Cá nhân',
        'path': '/profile/$username/personal',
      }
    ];
  }

  Widget buildTab(int index) {
    switch (index) {
      case 0:
        return _buildPostTab();
      case 1:
        return _buildPostTab(isQuestion: true);
      case 2:
        return _buildSeriesTab();
      case 3:
        return _buildBookmarksTab();
      case 4:
        return _buildFollowsTab();
      case 5:
        return _buildFollowsTab(isFollowers: true);
      case 6:
        return PersonalTab(username: username);
      default:
        return _buildPostTab();
    }
  }

  Widget _buildPostTab({bool isQuestion = false}) {
    return PostsTab(
        isQuestion: isQuestion, username: username, page: page, size: size);
  }

  Widget _buildSeriesTab() {
    return SeriesTab(username: username, page: page, size: size);
  }

  Widget _buildFollowsTab({bool isFollowers = false}) {
    return FollowsTab(
        isFollowers: isFollowers, username: username, page: page, size: size);
  }

  Widget _buildBookmarksTab() {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 16),
        child: const Text('Tính năng sẽ sớm ra mắt!'));
  }
}
