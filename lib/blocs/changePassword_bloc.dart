import 'dart:async';

import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/repositories/auth_repository.dart';
import 'package:it_forum/ui/common/utils/message_from_exception.dart';
import 'package:it_forum/ui/widgets/notification.dart';
import 'package:it_forum/validators/validations.dart';
import 'package:flutter/material.dart';

class ChangePasswordBloc {
  final StreamController _usernameController = StreamController();
  final StreamController _currentPassController = StreamController();
  final StreamController _passController = StreamController();
  final StreamController _repassController = StreamController();
  StreamController<String> loginStatusController = StreamController();
  final AuthRepository _userRepository = AuthRepository();

  Stream get usernameStream => _usernameController.stream;

  Stream get curentPasStream => _currentPassController.stream;

  Stream get pasStream => _passController.stream;

  Stream get repassStream => _repassController.stream;

  Stream get getloginStatusController => loginStatusController.stream;

  String username = "";

  late BuildContext context;

  ChangePasswordBloc(BuildContext context) {
    this.context = context;
  }

  Future<bool> isValidInfo(String username, String currentpassword,
      String newpassword, String repassword) async {
    Future<bool> isValid;

    if (username == "" || !Validations.isValidUsername(username)) {
      _usernameController.sink.addError("Tài khoản phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _usernameController.sink.add("");
    if (!Validations.isValidPassword(currentpassword)) {
      _currentPassController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự ");
      return Future<bool>.value(false);
    }
    _currentPassController.sink.add("");
    if (!Validations.isValidPassword(newpassword)) {
      _passController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _passController.sink.add("");

    if (!Validations.arePasswordsEqual(newpassword, repassword)) {
      _repassController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return Future<bool>.value(false);
    }
    _repassController.sink.add("");

    var future =
    _userRepository.changePassUser(username, currentpassword, newpassword);
    isValid = future.then((response) {
      showTopRightSnackBar(
          context, 'Đổi mật khẩu thành công!', NotifyType.success);
      return Future<bool>.value(true);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isValid;
  }

  void dispose() {
    _passController.close();
    _repassController.close();
  }
}
