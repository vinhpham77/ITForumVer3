import 'package:it_forum/dtos/series_post.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/result_count.dart';
import '../../../../../repositories/series_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'series_tab_event.dart';
part 'series_tab_state.dart';

class SeriesTabBloc extends Bloc<SeriesTabEvent, SeriesTabState> {
  final SeriesRepository _seriesRepository;

  SeriesTabBloc({required seriesRepository}) :
  _seriesRepository = seriesRepository
  , super(SeriesInitialState()) {
    on<LoadSeriesEvent>(_loadSeries);
    on<ConfirmDeleteEvent>(_confirmDelete);
  }

  Future<void> _loadSeries(
      LoadSeriesEvent event, Emitter<SeriesTabState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.getByUser(
        event.username,
        page: event.page,
        size: event.size,
      );

      ResultCount<SeriesPost> seriesUsers =
          ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesUsers.resultList.isEmpty) {
        emit(SeriesEmptyState());
      } else {
        emit(SeriesLoadedState(seriesPosts: seriesUsers));
      }
    } catch (error) {
      emit(const SeriesLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<SeriesTabState> emit) async {
    try {
      await _seriesRepository.delete(event.seriesPost.id!);
      emit(SeriesDeleteSuccessState(seriesPost: event.seriesPost));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(SeriesDeleteErrorState(
          message: message, seriesPosts: event.seriesPosts));
    }
  }
}
