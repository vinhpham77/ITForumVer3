import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/ui/views/profile/blocs/posts_tab/posts_tab_provider.dart';
import 'package:it_forum/ui/views/profile/widgets/posts_tab/post_tab_item.dart';
import 'package:it_forum/ui/widgets/notification.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../../dtos/post_user.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/posts_tab/posts_tab_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';

class PostsTab extends StatelessWidget {
  final String username;
  final int page;
  final int size;
  final bool isQuestion;

  const PostsTab(
      {super.key,
      required this.username,
      required this.page,
      required this.size,
      required this.isQuestion});

  Map<String, String> get target => isQuestion
      ? {"name": 'câu hỏi', "object": "questions"}
      : {"name": 'bài viết', "object": "posts"};

  @override
  Widget build(BuildContext context) {
    return PostsTabBlocProvider(
      username: username,
      page: page,
      limit: size,
      isQuestion: isQuestion,
      child: BlocListener<PostsTabBloc, PostsTabState>(
        listener: (context, state) {
          if (state is PostsDeleteSuccessState) {
            showTopRightSnackBar(
              context,
              "Xoá ${target['name']} \"${state.postUser.post.title}\" thành công!",
              NotifyType.success,
            );
            context.read<PostsTabBloc>().add(LoadPostsEvent(
                  username: username,
                  page: page,
                  limit: size,
                  isQuestion: isQuestion,
                ));
           final ProfileBloc profileBloc = context.read<ProfileBloc>();
            final profileState = profileBloc.state as ProfileSubState;

            profileBloc.add(DecreasePostsCountEvent(
              isFollowing: profileState.isFollowing,
              profileStats: profileState.profileStats,
              tagCounts: profileState.tagCounts,
              user: profileState.user,
              postUser: state.postUser,
            ));
          } else if (state is PostsTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<PostsTabBloc, PostsTabState>(
          builder: (context, state) {
            if (state is PostsEmptyState) {
              return buildSimpleContainer(
                child: Text(
                  "Không có ${target['name']} nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is PostsLoadedState) {
              return Column(
                children: [
                  buildPostList(context, state.postUsers),
                  buildPagination(state.postUsers),
                ],
              );
            } else if (state is PostsLoadErrorState) {
              return buildSimpleContainer(
                child:
                    Text(state.message, style: const TextStyle(fontSize: 16)),
              );
            } else if (state is PostsTabErrorState) {
              return Column(
                children: [
                  buildPostList(context, state.postUsers),
                  buildPagination(state.postUsers),
                ],
              );
            }

            return buildSimpleContainer(
                child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Container buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: child);

  Pagination2 buildPagination(ResultCount<PostUser> postUsers) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: postUsers.count,
            size: size,
            currentPage: page,
            range: 2,
            path: "/profile/$username/${target['object']}",
            params: {}));
  }

  Padding buildPostList(BuildContext context, ResultCount<PostUser> postUsers) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Column(
        children: [
          for (var postUser in postUsers.resultList)
            buildOneRow(context, postUser, postUsers),
        ],
      ),
    );
  }

  Row buildOneRow(
      BuildContext context, PostUser postUser, ResultCount<PostUser> postUsers) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-8.0, 0, 0),
            child: PostTabItem(postUser: postUser),
          ),
        ),
        if (username == JwtPayload.sub)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent[400],
                side: BorderSide(color: Colors.redAccent[400]!, width: 1),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                textStyle: const TextStyle(fontSize: 13)),
            onPressed: () =>
                showDeleteConfirmationDialog(context, postUser, postUsers),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, size: 16),
                SizedBox(width: 4),
                Text("Xoá")
              ],
            ),
          ),
      ],
    );
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, PostUser postUser, ResultCount<PostUser> postUsers) async {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Bạn có chắc chắn muốn xoá ${target['name']} "${postUser.post.title}" không?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Xác nhận'),
            onPressed: () {
              context
                  .read<PostsTabBloc>()
                  .add(ConfirmDeleteEvent(postUser: postUser, postUsers: postUsers));
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }
}
