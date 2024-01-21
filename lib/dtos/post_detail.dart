import 'package:it_forum/models/post.dart';
import 'package:it_forum/models/user.dart';

class PostDetail{
  final Post post;
  final User user;

  PostDetail({
  required this.post,
  required this.user});

  PostDetail.empty()
  :post=Post.empty(),
  user=User.empty();

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
        post: Post.fromJson(json['post']),
        user: User.fromJson(json['user']));
  }
}
