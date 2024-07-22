import 'package:flutter/cupertino.dart';
import 'package:flutter_study/constants.dart';
import 'package:flutter_study/repository/api.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:flutter_study/utils/sp_utils.dart';

class PersonalViewModel with ChangeNotifier {
  String? username;
  bool shouldLogin = false;

  Future initData() async {
    SpUtils.getString(Constants.SP_User_Name).then((value) {
      if (value == null || value == "") {
        username = "未登录";
        shouldLogin = true;
      } else {
        username = value;
        shouldLogin = false;
      }
      notifyListeners();
    });
  }

  Future logout(ValueChanged<bool> callback) async {
    bool? success = await Api.instance.logout();
    if (success == true) {
      await SpUtils.removeAll();
      callback.call(true);
    } else {
      callback.call(false);
    }
  }
}