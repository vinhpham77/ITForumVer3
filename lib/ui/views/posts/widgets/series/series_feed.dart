import 'package:it_forum/ui/views/posts/widgets/series_feed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination.dart';
import '../../blocs/series/series_bloc.dart';


class SeriesFeed extends StatefulWidget {
  final int page;
  final int limit;
  final Map<String, String> params;

  const SeriesFeed(
      {super.key,
        required this.page,
        required this.limit,
        required this.params
      });

  @override
  State<SeriesFeed> createState() => _SeriesFeedState();
}

class _SeriesFeedState extends State<SeriesFeed> {
  late SeriesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SeriesBloc()
      ..add(LoadSeriesEvent(
          limit: widget.limit,
          page: widget.page,
      ));
  }

  @override
  void didUpdateWidget(SeriesFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc..add(LoadSeriesEvent(
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
      child: BlocListener<SeriesBloc, SeriesState>(
        listener: (context, state) {
          if (state is SeriesTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<SeriesBloc, SeriesState>(
          builder: (context, state) {
            if (state is SeriesEmptyState) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Không có series nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is SeriesLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.seriesPost.resultList
                          .map((e) {
                        return SeriesFeedItem(
                            seriesPost: e);
                      }).toList()),
                  Pagination(
                    path: "viewseries",
                    totalItem: state.seriesPost.count,
                    params: widget.params,
                    selectedPage: widget.page,
                  )
                ],
              );
            } else if (state is SeriesLoadErrorState) {
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