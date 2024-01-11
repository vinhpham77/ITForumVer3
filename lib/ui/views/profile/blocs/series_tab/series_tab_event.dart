part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabEvent extends Equatable {
  const SeriesTabEvent();

  @override
  List<Object?> get props => [];
}

final class SeriesSubEvent extends SeriesTabEvent {
  final ResultCount<SeriesPost> seriesPosts;

  const SeriesSubEvent({
    required this.seriesPosts,
  });

  @override
  List<Object?> get props => [seriesPosts];
}

final class LoadSeriesEvent extends SeriesTabEvent {
  final String username;
  final int page;
  final int size;

  const LoadSeriesEvent(
      {required this.username, required this.page, required this.size});

  @override
  List<Object?> get props => [username, page, size];
}

final class ConfirmDeleteEvent extends SeriesSubEvent {
  final SeriesPost seriesPost;

  const ConfirmDeleteEvent({
    required this.seriesPost,
    required super.seriesPosts,
  });

  @override
  List<Object?> get props => [seriesPost, seriesPosts];
}

final class CancelDeleteEvent extends SeriesSubEvent {
  const CancelDeleteEvent({required super.seriesPosts});
}
