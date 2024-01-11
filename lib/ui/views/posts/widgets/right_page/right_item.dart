import 'package:flutter/material.dart';

import '../../../../../models/post.dart';
import '../../../../router.dart';

class RightItem extends StatelessWidget {
  final Post post;

  const RightItem({super.key, required this.post});

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
                appRouter.push('/posts/${post.id}', extra: {}),
            child: Text(
              post.title,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                post.score < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                size: 16,
                color: Colors.black87,
              ),
              Text('${post.score}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Text(
              post.createdBy.displayName,
              style: const TextStyle(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}
