import 'package:flutter/material.dart';
import 'package:it_forum/dtos/post_aggregation.dart';
import 'package:it_forum/ui/views/series_detail/tags.dart';
import 'package:it_forum/ui/widgets/user_avatar.dart';

class PostFeedItemSeries extends StatefulWidget {
  final PostAggregation postAggregation;

  const PostFeedItemSeries({
    super.key,
    required this.postAggregation,
  });

  @override
  State<PostFeedItemSeries> createState() => _PostFeedItemState();
}

class _PostFeedItemState extends State<PostFeedItemSeries> {
  bool isHoveredUserLink = false;
  bool isHoveredTitle = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                print('Navigate to: ${widget.postAggregation.id}');
              },
              child: ClipOval(
                
                child: UserAvatar(
                  imageUrl: widget.postAggregation.user.avatarUrl,
                  size: 54,
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Name
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                setState(() {
                  isHoveredUserLink = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHoveredUserLink = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  print('Navigate to: ${widget.postAggregation.id}');
                },
                child: Text(
                  widget.postAggregation.user.displayName,
                  style: TextStyle(
                    color: isHoveredUserLink
                        ? Colors.lightBlueAccent
                        : Colors.indigo,
                    decoration: isHoveredUserLink
                        ? TextDecoration.underline
                        : null,
                  ),
                ),
              ),
            ),
            // Title
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                setState(() {
                  isHoveredTitle = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHoveredTitle = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  print('Navigate to post: ${widget.postAggregation.id}');
                },
                child: Text(
                  widget.postAggregation.title,
                  style: TextStyle(
                    color: isHoveredTitle ? Colors.blue : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: TagListWidget(tags: widget.postAggregation.tags),
            ),
          ],
        )
      ],
    );
  }
}
