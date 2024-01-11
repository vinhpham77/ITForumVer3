import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/series_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_post.dart';

part 'series_event.dart';
part 'series_state.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository _seriesRepository = SeriesRepository();

  SeriesBloc() : super(SeriesInitialState()) {
    on<LoadSeriesEvent>(_loadSeries);
  }

  Future<void> _loadSeries(
      LoadSeriesEvent event, Emitter<SeriesState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.get(
        page: event.page,
        size: event.limit,
      );

      ResultCount<SeriesPost> seriesPost =
          ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPost.resultList.isEmpty) {
        emit(SeriesEmptyState());
      } else {
        emit(SeriesLoadedState(seriesPost: seriesPost));
      }
    } catch (error) {
      emit(const SeriesLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
