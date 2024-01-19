import 'dart:async';

import 'package:flutter/material.dart';
import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/repositories/auth_repository.dart';
import 'package:it_forum/ui/widgets/notification.dart';
import 'package:it_forum/validators/validations.dart';

import '../ui/common/utils/common_utils.dart';

class ForgotPasswordBloc {
  final StreamController _emailController = StreamController();

  StreamController<String> loginStatusController = StreamController();
  final AuthRepository _userRepository = AuthRepository();
  final StreamController _userController = StreamController();
  final StreamController _usernameController = StreamController();
  Stream get user => _userController.stream;
  Stream get usernameStream => _usernameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get getLoginStatusController => loginStatusController.stream;
  String username = "";
  static String requestName = "";
  late BuildContext context;

  ForgotPasswordBloc(this.context);
  Future<bool> isValidInfo(String username) {
    Future<bool> isValid;
    if (!Validations.isValidUsername(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return Future<bool>.value(false);
    }
    _usernameController.sink.add("");

    var future = _userRepository.forgotPassUser(username);
    isValid = future.then((response) {
      requestName=response.data;
      return Future<bool>.value(true);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isValid;
  }

  void dispose() {
    _emailController.close();
  }
}
