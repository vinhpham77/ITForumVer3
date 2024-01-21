import 'package:it_forum/models/comment_details.dart';

import 'comment_user.dart';

class CommentShow {
  CommentUser commentUser;
  List<CommentShow> commentShows;
  bool isReply;
  bool isShowChildren;
  bool isEdit;

  CommentShow(
      {required this.commentUser,
      List<CommentShow>? commentShows,
      this.isReply = false,
      this.isShowChildren = false,
      this.isEdit = false})
      : commentShows = commentShows ?? [];
}
