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
  final ResultCount<SeriesPostUser> seriesPostUsers;

  const SeriesSubState({
    required this.seriesPostUsers,
  });

  @override
  List<Object?> get props => [seriesPostUsers];
}

final class SeriesLoadedState extends SeriesSubState {
  const SeriesLoadedState({
    required super.seriesPostUsers,
  });
}

final class SeriesDeleteSuccessState extends SeriesTabState {
  final SeriesPostUser seriesPostUser;

  const SeriesDeleteSuccessState({required this.seriesPostUser});

  @override
  List<Object?> get props => [seriesPostUser];
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
    required super.seriesPostUsers,
  });

  @override
  List<Object?> get props => [message, super.seriesPostUsers];
}

final class SeriesLoadErrorState extends SeriesTabErrorState {
  const SeriesLoadErrorState({required super.message});
}
