import 'package:flutter/foundation.dart';
import 'package:flutter_study/constants.dart';
import 'package:flutter_study/repository/api.dart';
import 'package:flutter_study/repository/datas/auth_data.dart';
import 'package:flutter_study/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

class AuthViewModel with ChangeNotifier {
  RegisterInfo registerInfo = RegisterInfo();
  LoginInfo loginInfo = LoginInfo();

  Future<bool?> register() async {
    if (registerInfo.name != null &&
        registerInfo.password != null &&
        registerInfo.rePassword != null &&
        registerInfo.password == registerInfo.rePassword) {
      if ((registerInfo.password?.length ?? 0) >= 6) {
        dynamic callback = await Api.instance.register(
            name: registerInfo.name,
            password: registerInfo.password,
            rePassword: registerInfo.rePassword);
        if (callback is bool) {
          return callback;
        } else {
          return true;
        }
      }
      showToast("密码长度必须大于6位");
      return false;
    }
    showToast("输入不能为空或者密码必须一致");
    return false;
  }

  Future<bool?> login() async {
    if (loginInfo.name != null && loginInfo.password != null) {
      AuthData data = await Api.instance
          .login(name: loginInfo.name, password: loginInfo.password);
      if (data.username != null && data.username?.isNotEmpty == true) {
        SpUtils.saveString(Constants.SP_User_Name, data.username ?? '');
        return true;
      }
    }
    showToast("登录失败");
    return false;
  }

  void setLoginInfo({String? username, String? password}) {
    if (username != null) {
      loginInfo.name = username;
    }
    if (password != null) {
      loginInfo.password = password;
    }
  }
}

class RegisterInfo {
  String? name;
  String? password;
  String? rePassword;
}

class LoginInfo {
  String? name;
  String? password;
}
