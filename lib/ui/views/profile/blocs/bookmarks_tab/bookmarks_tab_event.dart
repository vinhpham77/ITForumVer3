part of 'bookmarks_tab_bloc.dart';

@immutable
sealed class BookmarksTabEvent extends Equatable {
  const BookmarksTabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBookmarksEvent extends BookmarksTabEvent {
  final String username;
  final int page;
  final int limit;
  final bool isPostBookmarks;

  const LoadBookmarksEvent({
    required this.isPostBookmarks,
    required this.username,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [username, page, limit, isPostBookmarks];
}

final class BookmarksTabSubEvent extends BookmarksTabEvent {
  final ResultCount<BookmarkUserItem> bookmarkUsers;
  final bool isPostBookmarks;

  const BookmarksTabSubEvent({required this.bookmarkUsers, required this.isPostBookmarks});

  @override
  List<Object?> get props => [bookmarkUsers, isPostBookmarks];
}

final class ConfirmDeleteEvent extends BookmarksTabSubEvent {
  final BookmarkUserItem bookmarkUser;

  const ConfirmDeleteEvent({
    required this.bookmarkUser,
    required super.bookmarkUsers,
    required super.isPostBookmarks,
  });

  @override
  List<Object?> get props => [bookmarkUser, bookmarkUsers, isPostBookmarks];
}

