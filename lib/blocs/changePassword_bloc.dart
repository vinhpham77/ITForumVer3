import 'dart:async';

import 'package:flutter/material.dart';
import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/repositories/auth_repository.dart';
import 'package:it_forum/ui/widgets/notification.dart';
import 'package:it_forum/validators/validations.dart';

import '../ui/common/utils/common_utils.dart';

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

  ChangePasswordBloc(this.context);

  Future<bool> isValidInfo(String username, String currentPassword,
      String newPassword, String rePassword) async {
    Future<bool> isValid;

    if (username == "" || !Validations.isValidUsername(username)) {
      _usernameController.sink.addError("Tài khoản phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _usernameController.sink.add("");
    if (!Validations.isValidPassword(currentPassword)) {
      _currentPassController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự ");
      return Future<bool>.value(false);
    }
    _currentPassController.sink.add("");
    if (!Validations.isValidPassword(newPassword)) {
      _passController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _passController.sink.add("");

    if (!Validations.arePasswordsEqual(newPassword, rePassword)) {
      _repassController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return Future<bool>.value(false);
    }
    _repassController.sink.add("");

    var future =
        _userRepository.changePassUser(username, currentPassword, newPassword);
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
