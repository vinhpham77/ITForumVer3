part of 'bookmarks_tab_bloc.dart';

@immutable
sealed class BookmarksTabState extends Equatable {
  const BookmarksTabState();

  @override
  List<Object?> get props => [];
}

final class BookmarksInitialState extends BookmarksTabState {}

final class BookmarksEmptyState extends BookmarksTabState {}

@immutable
sealed class BookmarksTabSubState extends BookmarksTabState {
  final bool isPostBookmarks;
  final ResultCount<BookmarkUserItem> bookmarkUsers;

  const BookmarksTabSubState(
      {required this.bookmarkUsers, required this.isPostBookmarks});

  @override
  List<Object?> get props => [isPostBookmarks, bookmarkUsers];
}

final class BookmarksLoadedState extends BookmarksTabSubState {
  const BookmarksLoadedState({
    required super.bookmarkUsers,
    required super.isPostBookmarks,
  });
}

final class BookmarksDeleteSuccessState extends BookmarksTabState {
  final BookmarkUserItem bookmarkUser;

  const BookmarksDeleteSuccessState({required this.bookmarkUser});

  @override
  List<Object?> get props => [bookmarkUser];
}

final class BookmarksTabErrorState extends BookmarksTabSubState {
  final String message;

  const BookmarksTabErrorState(
      {required this.message,
      required super.bookmarkUsers,
      required super.isPostBookmarks});

  @override
  List<Object?> get props => [message, super.bookmarkUsers, super.isPostBookmarks];
}

final class BookmarksLoadErrorState extends BookmarksTabState {
  final String message;

  const BookmarksLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
