import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages/auth/register_page.dart';
import '../routes/RouteUtils.dart';

//白色字体14号
TextStyle whiteTextStyle14 = TextStyle(color: Colors.white, fontSize: 14.sp);
//白色字体15号
TextStyle whiteTextStyle15 = TextStyle(color: Colors.white, fontSize: 15.sp);
//标题文本15号
TextStyle titleTextStyle15 = TextStyle(color: Colors.black, fontSize: 15.sp);
//黑色字体13号
TextStyle blackTextStyle13 = TextStyle(fontSize: 13.sp, color: Colors.black);

Text normalText(String? text) {
  return Text(
    text ?? "",
    style: titleTextStyle15,
  );
}

Widget commonInput(
    {String? labelText,
    ValueChanged<String>? onChanged,
    TextEditingController? controller,
    bool? obscureText}) {
  return TextField(
    onChanged: onChanged,
    controller: controller,
    obscureText: obscureText ?? false,
    style: TextStyle(color: Colors.white, fontSize: 14.sp),
    cursorColor: Colors.white,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5.r)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.r)),
        labelText: labelText ?? "",
        labelStyle: TextStyle(color: Colors.white)),
  );
}

Widget whiteBorderButton({required String title, GestureTapCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.only(left: 40.w, right: 40.w),
      decoration: BoxDecoration(
          border: Border.all(width: 1.r, color: Colors.white),
          borderRadius: BorderRadius.circular(22.5.r)),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 13.sp),
      ),
    ),
  );
}

Widget collectImage(bool? collect, {GestureTapCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Image.asset(
      collect == true
          ? "assets/images/img_collect.png"
          : "assets/images/img_collect_grey.png",
      width: 25.r,
      height: 25.r,
    ),
  );
}
