import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/bookmark_item.dart';
import '../../../../../dtos/post_user.dart';
import '../../../../../dtos/result_count.dart';
import '../../../../../models/bookmarkInfo.dart';
import '../../../../../models/post.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/bookmark_repository.dart';
import '../../../../../repositories/post_repository.dart';
import '../../../../../repositories/user_repository.dart';
import '../../../../common/utils/common_utils.dart';

part 'bookmarks_tab_event.dart';
part 'bookmarks_tab_state.dart';

class BookmarksTabBloc extends Bloc<BookmarksTabEvent, BookmarksTabState> {
  final BookmarkRepository _bookmarkRepository;
  final PostRepository _postRepository;
  final UserRepository _userRepository;

  BookmarksTabBloc(
      {required BookmarkRepository bookmarkRepository,
      required postRepository,
      required userRepository})
      : _bookmarkRepository = bookmarkRepository,
        _postRepository = postRepository,
        _userRepository = userRepository,
        super(BookmarksInitialState()) {
    on<LoadBookmarksEvent>(_loadBookmarks);
    on<ConfirmDeleteEvent>(_confirmDelete);
  }

  Future<void> _loadBookmarks(
      LoadBookmarksEvent event, Emitter<BookmarksTabState> emit) async {
    try {
      Response<dynamic> response = await _bookmarkRepository.getPostByUserName(
          username: event.username, page: event.page, limit: event.limit);
      ResultCount<int> postIds = ResultCount(
          resultList: List<int>.from(response.data['resultList']),
          count: response.data['count']);

      if (postIds.resultList.isEmpty) {
        emit(BookmarksEmptyState());
      } else {
        response = await _postRepository.getByIds(ids: postIds.resultList);
        List<Post> posts = (response.data as List<dynamic>)
            .map((e) => Post.fromJson(e))
            .toList();
        List<String> usernames = posts.map((e) => e.createdBy).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();
        List<PostUser> postUsers = convertPostUser(posts, users);
        ResultCount<BookmarkUserItem> bookmarkUsers = ResultCount<BookmarkUserItem>(
            count: postIds.count,
            resultList: aggregationBookmarkUser(postIds.resultList, postUsers));

        emit(BookmarksLoadedState(isPostBookmarks: event.isPostBookmarks, bookmarkUsers: bookmarkUsers));
      }
    } catch (error) {
      print(error);
      emit(const BookmarksLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<BookmarksTabState> emit) async {
    try {
      bool isPostBookmarkItem = event.bookmarkUser is PostBookmark;
      var bookmarkInfo = BookmarkInfo(
          targetId: event.bookmarkUser.bookmarkItem!.id!, type: isPostBookmarkItem);

      await _bookmarkRepository.unBookmark(bookmarkInfo);
      emit(BookmarksDeleteSuccessState(bookmarkUser: event.bookmarkUser));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(BookmarksTabErrorState(
          bookmarkUsers: event.bookmarkUsers,
          message: message,
          isPostBookmarks: event.isPostBookmarks));
    }
  }
}
