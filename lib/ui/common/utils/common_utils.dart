import 'package:dio/dio.dart';
import 'package:it_forum/dtos/comment_user.dart';
import 'package:it_forum/dtos/series_post.dart';
import 'package:it_forum/models/comment_details.dart';

import '../../../dtos/bookmark_item.dart';
import '../../../dtos/post_user.dart';
import '../../../dtos/series_post_user.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';

String getMessageFromException(dynamic err) {
  var error = err;

  if (err is DioException) {
    error = err;
  } else {
    return "Có lỗi xảy ra. Vui lòng thử lại sau!";
  }

  error as DioException;
  String message = "Có lỗi xảy ra. Vui lòng thử lại sau!";

  var errorMessage = error.response?.data;

  if (errorMessage is Map<String, dynamic>) {
    Map<String, dynamic> data = errorMessage;
    message =
        data.entries.map((entry) => "${entry.key}: ${entry.value}").join("\n");
  } else if (errorMessage is String && errorMessage.isNotEmpty) {
    message = errorMessage;
  } else if (error.type == DioExceptionType.connectionTimeout) {
    message = "Không thể kết nối đến máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.connectionError) {
    message = "Lỗi kết nối đến máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.sendTimeout) {
    message = "Không thể gửi dữ liệu đến máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.receiveTimeout) {
    message = "Không thể nhận dữ liệu từ máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.cancel) {
    message = "Yêu cầu đã bị hủy!";
  } else if (error.response?.statusCode == 401) {
    message = "Vui lòng đăng nhập!";
  } else if (error.response?.statusCode == 403) {
    message =
        "Bạn không thể thực hiện thao tác này! Vui lòng đăng nhập với tư cách khác!";
  } else if (error.response?.statusCode == 404) {
    message = "Không tìm thấy dữ liệu!";
  } else if (error.response?.statusCode == 500) {
    message = "Lỗi máy chủ!";
  } else if (error.response?.statusCode == 503) {
    message = "Máy chủ đang bảo trì!";
  } else if (error.response?.statusCode == 504) {
    message = "Không thể kết nối đến máy chủ. Vui lòng thử lại sau!";
  }

  return message;
}

String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    return '${dateTime.year} thg ${dateTime.month} ${dateTime.day}, ${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? "SA" : "CH"}';
  } else if (difference.inDays > 2) {
    return 'thg ${dateTime.month} ${dateTime.day}, ${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? "SA" : "CH"}';
  } else if (difference.inDays >= 1) {
    return 'hôm qua, ${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? "SA" : "CH"}';
  } else if (difference.inHours >= 1) {
    return 'khoảng ${difference.inHours} giờ trước';
  } else if (difference.inMinutes >= 1) {
    return 'khoảng ${difference.inMinutes} phút trước';
  } else {
    return 'vừa xong';
  }
}

String convertParam(Map params) =>
    params.entries.map((e) => '${e.key}=${e.value}').join('&');

List<PostUser> convertPostUser(List<Post> posts, List<User> users) {
  List<PostUser> postUsers = [];

  for (var post in posts) {
    var user =
        users.firstWhere((element) => element.username == post.createdBy);
    postUsers.add(PostUser(post: post, user: user));
  }

  return postUsers;
}

List<SeriesPostUser> convertSeriesPostUser(
    List<SeriesPost> series, List<User> users) {
  List<SeriesPostUser> seriesPostUsers = [];

  for (var seriesPost in series) {
    var user =
        users.firstWhere((element) => element.username == seriesPost.createdBy);
    seriesPostUsers.add(SeriesPostUser(seriesPost: seriesPost, user: user));
  }

  return seriesPostUsers;
}

List<CommentUser> convertCommentUser(List<CommentDetails> commentDetails, List<User> users) {
  List<CommentUser> commentUser = [];

  for (var comment in commentDetails) {
    var user =
    users.firstWhere((element) => element.username == comment.createdBy);
    commentUser.add(CommentUser(commentDetails: comment, user: user));
  }

  return commentUser;
}

List<PostUser> aggregationPost(List<int> postIds, List<PostUser> postsUsers) {
   return postIds.map((e) {
      return postsUsers.firstWhere(
            (element) => element.post.id == e,
        orElse: () {
          return PostUser.empty();
        });
  }).toList();
}

List<SeriesPostUser> aggregationSeries(List<int> seriesIds, List<SeriesPostUser> seriesPostUsers) {
  return seriesIds.map((e) {
    return seriesPostUsers.firstWhere(
            (element) => element.seriesPost.id == e,
        orElse: () {
          return SeriesPostUser.empty();
        });
  }).toList();
}

aggregationBookmarkUser(List<int> resultList, List<PostUser> postUsers) {
  List<BookmarkUserItem> bookmarkUserItems = [];
  for (var id in resultList) {
    PostUser? postUser;
    try {
       postUser = postUsers.firstWhere((element) => element.post.id == id);
    } catch (error) {
      postUser = PostUser.empty();
    }

    var bookmarkItem = PostBookmark(
        id: postUser.post.id,
        title: postUser.post.title,
        content: postUser.post.content,
        createdBy: postUser.post.createdBy,
        commentCount: postUser.post.commentCount,
        private: postUser.post.isPrivate,
        score: postUser.post.score,
        tags: postUser.post.tags,
        updatedAt: postUser.post.updatedAt);

    bookmarkUserItems.add(BookmarkUserItem(
        bookmarkItem: bookmarkItem,
        user: postUser.user));
  }
  return bookmarkUserItems;
}