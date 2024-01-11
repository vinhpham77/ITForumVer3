import 'dart:async';

import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/models/series.dart';
import 'package:it_forum/repositories/series_repository.dart';
import 'package:it_forum/ui/common/utils/message_from_exception.dart';
import 'package:it_forum/ui/widgets/notification.dart';
import 'package:flutter/material.dart';

import '../models/sp.dart';
import '../repositories/sp_repository.dart';

class SeriesDetailBloc {
  final StreamController<Series> _spController = StreamController<Series>();
  final SeriesRepository  _spRepository = SeriesRepository();

  late BuildContext context;

  SeriesDetailBloc({required this.context});

  Stream<Series> get spStream => _spController.stream;

  Future<void> getOneSP(int id) async {
    var future = _spRepository.getOne(id);
    future.then((response) {
      Series series  = Series.fromJson(response.data);

      _spController.add(series);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      _spController.addError("");
    });
  }

  void dispose() {
    _spController.close();
  }
}