import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/pages/home/home_page.dart';
import 'package:flutter_study/pages/web_view_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.home:
        return pageRoute(HomePage());
      case RoutePath.webViewPage:
        return pageRoute(WebViewPage(title: '首页跳转来的'));
    }
    return pageRoute(Scaffold(
        body:
            SafeArea(child: Center(child: Text('路由： ${settings.name} 不存在')))));
  }

  static MaterialPageRoute pageRoute(Widget page,
      {RouteSettings? settings,
      bool? fullscreenDialog,
      bool? maintainState,
      bool? allowSnapshotting}) {
    return MaterialPageRoute(
        builder: (context) {
          return page;
        },
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}

class RoutePath {
  // 首页
  static const String home = '/';

  static const String webViewPage = '/web_view_page';
}
