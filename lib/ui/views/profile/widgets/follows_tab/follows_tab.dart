import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/ui/views/profile/widgets/follows_tab/follow_tab_item.dart';
import 'package:it_forum/ui/widgets/notification.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/follows_tab/follows_tab_bloc.dart';
import '../../blocs/follows_tab/follows_tab_provider.dart';
import '../../blocs/profile/profile_bloc.dart';

class FollowsTab extends StatelessWidget {
  final String username;
  final int page;
  final int size;
  final bool isFollowers;

  const FollowsTab({
    super.key,
    required this.username,
    required this.page,
    required this.size,
    required this.isFollowers,
  });

  bool get isAuthorised => JwtPayload.sub != null && JwtPayload.sub == username;

  String get object => isFollowers ? "followers" : "followings";

  @override
  Widget build(BuildContext context) {
    return FollowsTabBlocProvider(
      username: username,
      page: page,
      size: size,
      isFollowed: isFollowers,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileFollowedState ||
                  state is ProfileUnfollowedState) {
                state as ProfileSubState;
                context.read<FollowsTabBloc>().add(LoadFollowsEvent(
                    username: username,
                    page: page,
                    size: size,
                    isFollowed: isFollowers));
              }
            },
          ),
          BlocListener<FollowsTabBloc, FollowsTabState>(
            listener: (context, state) {
              if (state is FollowsLoadErrorState) {
                showTopRightSnackBar(context, state.message, NotifyType.error);
              }
            },
          ),
        ],
        child: BlocBuilder<FollowsTabBloc, FollowsTabState>(
          builder: (context, state) {
            if (state is FollowsEmptyState) {
              return buildSimpleContainer(
                  child: Center(
                      child: isFollowers
                          ? const Text("Người dùng chưa có người theo dõi nào",
                              style: TextStyle(fontSize: 16))
                          : const Text("Người dùng chưa theo dõi ai",
                              style: TextStyle(fontSize: 16))));
            } else if (state is FollowsSubState) {
              return Column(
                children: [
                  _buildFollowList(context, state),
                  _buildPagination(state),
                ],
              );
            } else if (state is FollowsLoadErrorState) {
              return buildSimpleContainer(
                  child: Center(
                      child: Text(state.message,
                          style: const TextStyle(fontSize: 16))));
            }

            return buildSimpleContainer(
                child: const Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }

  Container buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: child);

  Widget _buildFollowList(BuildContext context, FollowsSubState state) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Wrap(
        spacing: 20,
        children: [
          for (var userMetrics in state.userStatsList.resultList)
            FollowTabItem(
              userStats: userMetrics,
              isFollowingsTab: !isFollowers,
              isAuthorised: isAuthorised,
            ),
        ],
      ),
    );
  }

  Pagination2 _buildPagination(FollowsSubState state) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: state.userStatsList.count,
            size: size,
            currentPage: page,
            range: 2,
            path: "/profile/$username/$object",
            params: {}));
  }
}
