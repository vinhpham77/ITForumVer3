import 'package:flutter/material.dart';

import '../../../../../dtos/post_user.dart';
import '../../../../router.dart';

class RightItem extends StatelessWidget {
  final PostUser postUser;

  const RightItem({super.key, required this.postUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black38))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                appRouter.push('/posts/${postUser.post.id}', extra: {}),
            child: Text(
              postUser.post.title,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildFieldCount(Icons.comment_outlined, postUser.post.commentCount),
              buildFieldCount(
                  postUser.post.score < 0
                      ? Icons.trending_down_outlined
                      : Icons.trending_up_outlined,
                  postUser.post.score),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Text(
              postUser.user.displayName,
              style: const TextStyle(color: Colors.black38),
            ),
          ),
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
