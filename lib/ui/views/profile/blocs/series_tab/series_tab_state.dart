part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabState extends Equatable {
  const SeriesTabState();

  @override
  List<Object?> get props => [];
}

final class SeriesInitialState extends SeriesTabState {}

final class SeriesEmptyState extends SeriesTabState {}

@immutable
final class SeriesSubState extends SeriesTabState {
  final ResultCount<SeriesPost> seriesPosts;

  const SeriesSubState({
    required this.seriesPosts,
  });

  @override
  List<Object?> get props => [seriesPosts];
}

final class SeriesLoadedState extends SeriesSubState {
  const SeriesLoadedState({
    required super.seriesPosts,
  });
}

final class SeriesDeleteSuccessState extends SeriesTabState {
  final SeriesPost seriesPost;

  const SeriesDeleteSuccessState({required this.seriesPost});

  @override
  List<Object?> get props => [seriesPost];
}

@immutable
sealed class SeriesTabErrorState extends SeriesTabState {
  final String message;

  const SeriesTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SeriesDeleteErrorState extends SeriesSubState {
  final String message;

  const SeriesDeleteErrorState({
    required this.message,
    required super.seriesPosts,
  });

  @override
  List<Object?> get props => [message, super.seriesPosts];
}

final class SeriesLoadErrorState extends SeriesTabErrorState {
  const SeriesLoadErrorState({required super.message});
}
