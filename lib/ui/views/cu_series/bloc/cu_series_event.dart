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
  final List<Post> posts;
  final List<Post> selectedPosts;
  final bool isEditMode;

  const CuSeriesSubEvent({
    required this.isEditMode,
    required this.seriesPost,
    required this.selectedPosts,
    required this.posts,
  });

  @override
  List<Object?> get props =>
      [isEditMode, seriesPost, selectedPosts, posts];
}

final class AddPostEvent extends CuSeriesSubEvent {
  final Post post;

  const AddPostEvent(
      {required this.post,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPosts,
      required super.posts});

  @override
  List<Object?> get props => [
        post,
        super.isEditMode,
        super.seriesPost,
        super.selectedPosts,
        super.posts
      ];
}

final class RemovePostEvent extends CuSeriesSubEvent {
  final Post post;

  const RemovePostEvent(
      {required this.post,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPosts,
      required super.posts});

  @override
  List<Object?> get props => [
        post,
        super.isEditMode,
        super.seriesPost,
        super.selectedPosts,
        super.posts
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
      required super.selectedPosts,
      required super.posts});

  @override
  List<Object?> get props => [
        seriesDTO,
        super.isEditMode,
        super.seriesPost,
        super.selectedPosts,
        super.posts,
        isCreate
      ];
}

final class UpdateSeriesEvent extends CuSeriesSubEvent {
  final SeriesDTO seriesDTO;

  const UpdateSeriesEvent(
      {required this.seriesDTO,
      required super.isEditMode,
      required super.seriesPost,
      required super.selectedPosts,
      required super.posts});

  @override
  List<Object?> get props => [
        seriesDTO,
        super.isEditMode,
        super.seriesPost,
        super.selectedPosts,
        super.posts
      ];
}

final class SwitchModeEvent extends CuSeriesSubEvent {
  const SwitchModeEvent(
      {required super.isEditMode,
      required super.seriesPost,
      required super.selectedPosts,
      required super.posts});
}
