import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/series_repository.dart';

import '../../../../../dtos/series_post.dart';
import '../../../../../dtos/series_post_user.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/user_repository.dart';
import '../../../../common/utils/common_utils.dart';

part 'series_event.dart';
part 'series_state.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository _seriesRepository = SeriesRepository();
  final UserRepository _userRepository = UserRepository();

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

      ResultCount<SeriesPost> seriesPosts =
          ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPosts.resultList.isEmpty) {
        emit(SeriesEmptyState());
      } else {
        List<String> usernames =
        seriesPosts.resultList.map((e) => e.createdBy!).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<SeriesPostUser> seriesPostUsers =
        convertSeriesPostUser(seriesPosts.resultList, users);

        ResultCount<SeriesPostUser> seriesPostUserResults =
        ResultCount<SeriesPostUser>(
            count: seriesPosts.count, resultList: seriesPostUsers);

        emit(SeriesLoadedState(seriesPostUsers: seriesPostUserResults));
      }
    } catch (error) {
      emit(const SeriesLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
