import 'package:flutter/material.dart';

import '../../../../../dtos/bookmark_item.dart';
import '../../../../common/utils/common_utils.dart';
import '../../../../router.dart';
import '../../../../widgets/user_avatar.dart';

class SeriesBookmarkItem extends StatelessWidget {
  final BookmarkUserItem bookmarkUser;

  const SeriesBookmarkItem({super.key, required this.bookmarkUser});

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Padding _buildContainer() {
    final TextStyle fieldCountStyle =
        TextStyle(fontSize: 13, color: Colors.grey[700]);
    final TextStyle timeStyle = TextStyle(
      fontSize: 13,
      color: Colors.grey[700],
      fontWeight: FontWeight.w300,
    );

    var seriesBookmark = bookmarkUser.bookmarkItem as SeriesBookmark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: InkWell(
              onTap: bookmarkUser.user == null
                  ? null
                  : () => {
                        appRouter.go(
                            '/profile/${bookmarkUser.bookmarkItem?.createdBy}',
                            extra: {})
                      },
              hoverColor: Colors.black12,
              child: UserAvatar(
                imageUrl: bookmarkUser.user?.avatarUrl,
                size: 54,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: bookmarkUser.user == null
                          ? null
                          : () => {
                                appRouter.go(
                                    '/profile/${bookmarkUser.bookmarkItem?.createdBy}',
                                    extra: {})
                              },
                      hoverColor: Colors.black12,
                      child: Text(
                        bookmarkUser.user?.displayName ?? 'Người dùng ẩn danh',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.indigo[700]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    buildIconField(Icons.auto_fix_high_outlined,
                        getTimeAgo(bookmarkUser.bookmarkItem!.updatedAt!), timeStyle),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: InkWell(
                    onTap: bookmarkUser.bookmarkItem?.title == null
                        ? null
                        : () => {
                              appRouter
                                  .go('/posts/${bookmarkUser.bookmarkItem?.id}', extra: {})
                            },
                    hoverColor: Colors.black12,
                    child: Text(
                      bookmarkUser.bookmarkItem?.title ?? 'Series không còn tồn tại',
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
                    buildIconField(
                        Icons.backup_table_rounded,
                        seriesBookmark.postIds.length.toString(),
                        fieldCountStyle),
                    buildIconField(Icons.comment_outlined,
                        bookmarkUser.bookmarkItem!.commentCount.toString(), fieldCountStyle),
                    buildIconField(
                        bookmarkUser.bookmarkItem!.score < 0
                            ? Icons.trending_down_outlined
                            : Icons.trending_up_outlined,
                        bookmarkUser.bookmarkItem!.score.toString(),
                        fieldCountStyle)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconField(IconData icon, String text, TextStyle textStyle) {
    if (text.isEmpty) {
      return Container();
    }

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
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
