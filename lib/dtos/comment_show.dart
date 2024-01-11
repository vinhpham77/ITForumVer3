
import 'package:it_forum/models/comment_details.dart';

class CommentShow {
  CommentDetails commentDetails;
  List<CommentShow> commentShows;
  bool isReply;
  bool isShowChildren;
  bool isEdit;

  CommentShow({required this.commentDetails, List<CommentShow>? commentShows, this.isReply = false, this.isShowChildren = false, this.isEdit = false})
      : commentShows = commentShows ?? [];

}