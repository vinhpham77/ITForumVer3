part of 'cu_series_bloc.dart';

@immutable
sealed class CuSeriesEvent extends Equatable {
  const CuSeriesEvent();

  @override
  List<Object?> get props => [];
}

final class InitEmptySeriesEvent extends CuSeriesEvent {}

sealed class CuSeriesSubEvent extends CuSeriesEvent {
  final SeriesPost? seriesPost;
  final List<PostUser> postUsers;
  final List<PostUser> selectedPostUsers;
  final bool isEditMode;

  const CuSeriesSubEvent({
    required this.isEditMode,
    required this.seriesPost,
    required this.selectedPostUsers,
    required this.postUsers,
  });

  @override
  List<Object?> get props =>
      [isEditMode, seriesPost, selectedPostUsers, postUsers];
}

final class AddPostEvent extends CuSeriesSubEvent {
  final PostUser postUser;

  const AddPostEvent(
      {required this.postUser,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        postUser,
        super.isEditMode,
        super.seriesPost,
        super.selectedPostUsers,
        super.postUsers
      ];
}

final class RemovePostEvent extends CuSeriesSubEvent {
  final PostUser postUser;

  const RemovePostEvent(
      {required this.postUser,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        postUser,
        super.isEditMode,
        super.seriesPost,
        super.selectedPostUsers,
        super.postUsers
      ];
}

final class LoadSeriesEvent extends CuSeriesEvent {
  final int id;

  const LoadSeriesEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

final class CuSeriesOperationEvent extends CuSeriesSubEvent {
  final SeriesDTO seriesDTO;
  final bool isCreate;

  const CuSeriesOperationEvent(
      {required this.seriesDTO,
      required this.isCreate,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        seriesDTO,
        super.isEditMode,
        super.seriesPost,
        super.selectedPostUsers,
        super.postUsers,
        isCreate
      ];
}

final class UpdateSeriesEvent extends CuSeriesSubEvent {
  final SeriesDTO seriesDTO;

  const UpdateSeriesEvent(
      {required this.seriesDTO,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        seriesDTO,
        super.isEditMode,
        super.seriesPost,
        super.selectedPostUsers,
        super.postUsers
      ];
}

final class SwitchModeEvent extends CuSeriesSubEvent {
  const SwitchModeEvent(
      {required super.isEditMode,
      required super.seriesPost,
      required super.selectedPostUsers,
      required super.postUsers});
}
