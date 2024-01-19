import 'package:flutter/material.dart';
import 'package:it_forum/ui/widgets/user_avatar.dart';

import '../../../../../dtos/series_post_user.dart';
import '../../../../common/utils/common_utils.dart';
import '../../../../router.dart';

class SeriesTabItem extends StatelessWidget {
  final SeriesPostUser seriesPostUser;

  const SeriesTabItem({super.key, required this.seriesPostUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: UserAvatar(
                imageUrl: seriesPostUser.user.avatarUrl,
                size: 54,
              )),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      seriesPostUser.user.displayName,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.indigo[700]),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(seriesPostUser.seriesPost.updatedAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: InkWell(
                    onTap: () => appRouter.go(
                        '/series/${seriesPostUser.seriesPost.id}',
                        extra: {}),
                    hoverColor: Colors.black12,
                    child: Text(
                      seriesPostUser.seriesPost.title,
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
                    buildFieldCount(Icons.backup_table_rounded,
                        seriesPostUser.seriesPost.postIds.length),
                    buildFieldCount(Icons.comment_outlined,
                        seriesPostUser.seriesPost.commentCount),
                    buildFieldCount(
                        seriesPostUser.seriesPost.score < 0
                            ? Icons.trending_down_outlined
                            : Icons.trending_up_outlined,
                        seriesPostUser.seriesPost.score)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildFieldCount(IconData icon, int count) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
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
