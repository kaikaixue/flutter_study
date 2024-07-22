import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/pages/auth/auth_vm.dart';
import 'package:flutter_study/pages/auth/register_page.dart';
import 'package:flutter_study/pages/tab_page.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:provider/provider.dart';

import '../../common_ui/common_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  AuthViewModel viewModel = AuthViewModel();
  TextEditingController? userInputController;
  TextEditingController? pwdInputController;

  @override
  void initState() {
    super.initState();
    userInputController = TextEditingController();
    pwdInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
          backgroundColor: Colors.teal,
          body: Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonInput(
                      labelText: "输入账号", controller: userInputController),
                  SizedBox(height: 20.h),
                  commonInput(
                      labelText: "输入密码",
                      obscureText: true,
                      controller: pwdInputController),
                  SizedBox(
                    height: 50.h,
                  ),
                  whiteBorderButton(title: '开始登录', onTap: () {
                    viewModel.setLoginInfo(username: userInputController?.text ?? "", password: pwdInputController?.text ?? "");
                    viewModel.login().then((value) {
                      if (value == true) {
                        RouteUtils.pushAndRemoveUntil(context, TabPage());
                      }
                    });
                  }),
                  SizedBox(
                    height: 5.h,
                  ),
                  registerButton(() {
                    RouteUtils.push(context, const RegisterPage());
                  })
                ],
              ),
            ),
          )),
    );
  }

  Widget registerButton(GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100.w,
        height: 45.h,
        child: Text(
          '注册',
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ),
    );
  }
}
