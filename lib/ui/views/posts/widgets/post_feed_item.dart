import 'package:flutter/material.dart';
import 'package:it_forum/ui/widgets/user_avatar.dart';

import '../../../../dtos/post_user.dart';
import '../../../common/utils/common_utils.dart';
import '../../../router.dart';

class PostFeedItem extends StatelessWidget {
  final PostUser postUser;

  const PostFeedItem({super.key, required this.postUser});

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Container _buildContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: postUser.user == null
                ? null
                : () => appRouter.go('/profile/${postUser.user}', extra: {}),
            child: ClipOval(
                child: UserAvatar(
              imageUrl: postUser.user.avatarUrl,
              size: 54,
            )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: postUser.user == null
                          ? null
                          : () => appRouter.go(
                              '/profile/${postUser.user.username}',
                              extra: {}),
                      child: Text(
                        postUser.user.displayName,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.indigo[700]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(postUser.post.updatedAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: InkWell(
                    onTap: () =>
                        {appRouter.go('/posts/${postUser.post.id}', extra: {})},
                    hoverColor: Colors.black12,
                    child: Text(
                      postUser.post.title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Row(children: [
                      for (var tag in postUser.post.tags)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      buildFieldCount(
                          Icons.comment_outlined, postUser.post.commentCount),
                      buildFieldCount(
                          postUser.post.score < 0
                              ? Icons.trending_down_outlined
                              : Icons.trending_up_outlined,
                          postUser.post.score),
                    ]),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildFieldCount(IconData icon, int count) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 2),
          Text('$count',
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
