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
            onTap: () => appRouter.push('/posts/${postUser.post.id}', extra: {}),
            child: Text(
              postUser.post.title,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                postUser.post.score < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                size: 16,
                color: Colors.black87,
              ),
              Text('${postUser.post.score}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87)),
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
}
