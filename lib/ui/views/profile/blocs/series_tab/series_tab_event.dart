part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabEvent extends Equatable {
  const SeriesTabEvent();

  @override
  List<Object?> get props => [];
}

final class SeriesSubEvent extends SeriesTabEvent {
  final ResultCount<SeriesPostUser> seriesPostUsers;

  const SeriesSubEvent({
    required this.seriesPostUsers,
  });

  @override
  List<Object?> get props => [seriesPostUsers];
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
  final SeriesPostUser seriesPostUser;

  const ConfirmDeleteEvent({
    required this.seriesPostUser,
    required super.seriesPostUsers,
  });

  @override
  List<Object?> get props => [seriesPostUser, seriesPostUsers];
}

final class CancelDeleteEvent extends SeriesSubEvent {
  const CancelDeleteEvent({required super.seriesPostUsers});
}
