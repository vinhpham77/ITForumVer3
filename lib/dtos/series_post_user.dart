import 'package:it_forum/dtos/series_post.dart';

import '../models/user.dart';

class SeriesPostUser {
  SeriesPost seriesPost;
  User user;

  SeriesPostUser({required this.seriesPost, required this.user});

  SeriesPostUser copyWith({
    SeriesPost? seriesPost,
    User? user,
  }) {
    return SeriesPostUser(
      seriesPost: seriesPost ?? this.seriesPost,
      user: user ?? this.user,
    );
  }

  static SeriesPostUser empty() {
    return SeriesPostUser(
      seriesPost: SeriesPost.empty(),
      user: User.empty(),
    );
  }
}
