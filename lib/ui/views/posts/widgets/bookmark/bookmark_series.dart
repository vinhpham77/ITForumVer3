import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination.dart';
import '../../blocs/bookmark/bookmark_bloc.dart';
import '../series_feed_item.dart';

class BookmarkSeries extends StatefulWidget {
  final String username;
  final int page;
  final int limit;
  final Map<String, String> params;

  const BookmarkSeries(
      {super.key,
      required this.username,
      required this.page,
      required this.limit,
      required this.params});

  @override
  State<BookmarkSeries> createState() => _BookmarkSeriesState();
}

class _BookmarkSeriesState extends State<BookmarkSeries> {
  late BookmarkBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BookmarkBloc()
      ..add(LoadBookmarkSeriesEvent(
        username: widget.username,
        limit: widget.limit,
        page: widget.page,
      ));
  }

  @override
  void didUpdateWidget(BookmarkSeries oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.add(LoadBookmarkSeriesEvent(
      username: widget.username,
      limit: widget.limit,
      page: widget.page,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<BookmarkBloc, BookmarkState>(
        listener: (context, state) {
          if (state is BookmarkTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            if (state is BookmarkEmptyState) {
              return Container(
                alignment: Alignment.center,
                child: const Text(
                  "Không có series nào!",
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else if (state is BookmarkSeriesLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.seriesPostUsers.resultList.map((e) {
                    return SeriesFeedItem(seriesPostUser: e);
                  }).toList()),
                  Pagination(
                    path: "viewseries",
                    totalItem: state.seriesPostUsers.count,
                    params: widget.params,
                    selectedPage: widget.page,
                  )
                ],
              );
            } else if (state is BookmarkLoadErrorState) {
              return Container(
                alignment: Alignment.center,
                child:
                    Text(state.message, style: const TextStyle(fontSize: 16)),
              );
            }

            return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
