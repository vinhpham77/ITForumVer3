import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/repositories/post_repository.dart';
import 'package:it_forum/repositories/user_repository.dart';

import '../../../../../repositories/bookmark_repository.dart';
import 'bookmarks_tab_bloc.dart';

class BookmarksTabProvider extends StatelessWidget {
  final Widget child;
  final String username;
  final int page;
  final int limit;
  final bool isPostBookmarks;

  const BookmarksTabProvider(
      {super.key,
      required this.child,
      required this.username,
      required this.page,
      required this.limit,
      required this.isPostBookmarks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookmarksTabBloc>(
      create: (context) {
        final bloc = BookmarksTabBloc(
            bookmarkRepository: BookmarkRepository(),
            postRepository: PostRepository(),
            userRepository: UserRepository())
          ..add(LoadBookmarksEvent(
              username: username,
              page: page,
              limit: limit,
              isPostBookmarks: isPostBookmarks));

        return bloc;
      },
      child: child,
    );
  }
}
