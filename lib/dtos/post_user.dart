import '../models/post.dart';
import '../models/user.dart';

class PostUser {
  Post post;
  User user;

  PostUser({
    required this.post,
    required this.user,
  });

  PostUser copyWith({
    Post? post,
    User? user,
  }) {
    return PostUser(
      post: post ?? this.post,
      user: user ?? this.user,
    );
  }

  static PostUser empty() {
    return PostUser(
      post: Post.empty(),
      user: User.empty(),
    );
  }
}
