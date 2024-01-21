part of 'series_bloc.dart';

@immutable
sealed class SeriesState extends Equatable {
  const SeriesState();

  @override
  List<Object?> get props => [];
}

final class SeriesInitialState extends SeriesState {}

final class SeriesEmptyState extends SeriesState {}

final class SeriesLoadedState extends SeriesState {
  final ResultCount<SeriesPostUser> seriesPostUsers;

  const SeriesLoadedState({required this.seriesPostUsers});

  @override
  List<Object?> get props => [seriesPostUsers];
}

final class SeriesTabErrorState extends SeriesState {
  final String message;

  const SeriesTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SeriesLoadErrorState extends SeriesState {
  final String message;

  const SeriesLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
