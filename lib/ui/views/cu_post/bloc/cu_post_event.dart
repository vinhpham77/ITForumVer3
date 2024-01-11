part of 'cu_post_bloc.dart';

@immutable
sealed class CuPostEvent extends Equatable {
  const CuPostEvent();

  @override
  List<Object?> get props => [];
}

@immutable
sealed class CuPostQuestionEvent extends CuPostEvent {
  final bool isQuestion;

  const CuPostQuestionEvent({required this.isQuestion});

  @override
  List<Object?> get props => [isQuestion];
}

final class InitEmptyPostEvent extends CuPostQuestionEvent {
  const InitEmptyPostEvent({required super.isQuestion});
}

@immutable
sealed class CuPostSubEvent extends CuPostQuestionEvent {
  final Post? post;
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final bool isEditMode;

  const CuPostSubEvent({
    required this.isEditMode,
    required this.post,
    required this.selectedTags,
    required this.tags,
    required super.isQuestion,
  });

  @override
  List<Object?> get props =>
      [isEditMode, post, selectedTags, tags, super.isQuestion];
}

@immutable
sealed class CuPostTagEvent extends CuPostSubEvent {
  final Tag tag;

  const CuPostTagEvent(
      {required this.tag,
      required super.isEditMode,
      required super.post,
      required super.selectedTags,
      required super.tags,
      required super.isQuestion});

  @override
  List<Object?> get props => [
        tag,
        super.isEditMode,
        super.post,
        super.selectedTags,
        super.tags,
        super.isQuestion
      ];
}

final class AddTagEvent extends CuPostTagEvent {
  const AddTagEvent(
      {required super.tag,
      required super.isEditMode,
      required super.post,
      required super.selectedTags,
      required super.tags,
      required super.isQuestion});
}

final class RemoveTagEvent extends CuPostTagEvent {
  const RemoveTagEvent(
      {required super.tag,
      required super.isEditMode,
      required super.post,
      required super.selectedTags,
      required super.tags,
      required super.isQuestion});
}

final class CuPostOperationEvent extends CuPostSubEvent {
  final PostDTO postDTO;
  final bool isCreate;

  const CuPostOperationEvent(
      {required this.isCreate, required super.isEditMode,
      required super.post,
      required super.selectedTags,
      required super.tags,
      required super.isQuestion,
      required this.postDTO});

  @override
  List<Object?> get props => [
        postDTO,
        isCreate,
        super.isEditMode,
        super.post,
        super.selectedTags,
        super.tags,
        super.isQuestion
      ];
}

final class LoadPostEvent extends CuPostQuestionEvent {
  final int id;

  const LoadPostEvent({required this.id, required super.isQuestion});

  @override
  List<Object?> get props => [id, super.isQuestion];
}

final class SwitchModeEvent extends CuPostSubEvent {
  const SwitchModeEvent(
      {required super.isEditMode,
      required super.post,
      required super.selectedTags,
      required super.tags,
      required super.isQuestion});
}
