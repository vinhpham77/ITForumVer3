import 'package:it_forum/models/comment_details.dart';

import '../models/user.dart';

class CommentUser {
  CommentDetails commentDetails;
  User user;

  CommentUser({
    required this.commentDetails,
    required this.user,
  });

  CommentUser copyWith({
    CommentDetails? comment,
    User? user,
  }) {
    return CommentUser(
      commentDetails: comment ?? this.commentDetails,
      user: user ?? this.user,
    );
  }

  static CommentUser empty() {
    return CommentUser(
      commentDetails: CommentDetails.empty(),
      user: User.empty(),
    );
  }
}