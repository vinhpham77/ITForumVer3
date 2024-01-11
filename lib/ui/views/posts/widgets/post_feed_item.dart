import 'package:it_forum/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../../models/post.dart';
import '../../../common/utils/date_time.dart';
import '../../../router.dart';

class PostFeedItem extends StatelessWidget {
  final Post post;

  const PostFeedItem({super.key, required this.post});

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
            onTap: () => appRouter.go('/profile/${post.createdBy!.username}', extra: {}),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: UserAvatar(
                  imageUrl: post.createdBy!.avatarUrl,
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
                      onTap: () => appRouter.go('/profile/${post.createdBy!.username}', extra: {}),
                      child: Text(
                        post.createdBy!.displayName,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.indigo[700]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(post.updatedAt),
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
                    onTap: () => {appRouter.go('/posts/${post.id}', extra: {})},
                    hoverColor: Colors.black12,
                    child: Text(
                      post.title,
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
                      for (var tag in post.tags)
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
                      buildFieldCount(Icons.comment_outlined, post.commentCount),
                      buildFieldCount(
                          post.score < 0
                              ? Icons.trending_down_outlined
                              : Icons.trending_up_outlined,
                          post.score),
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
