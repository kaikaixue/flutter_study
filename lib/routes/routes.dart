import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/common_ui/web/webview_widget.dart';
import 'package:flutter_study/pages/auth/login_page.dart';
import 'package:flutter_study/pages/auth/register_page.dart';
import 'package:flutter_study/pages/home/home_page.dart';
import 'package:flutter_study/pages/knowledge/detail/knowledge_detail_tab_page.dart';
import 'package:flutter_study/pages/my_collects/my_collects_page.dart';
import 'package:flutter_study/pages/search/search_page.dart';
import 'package:flutter_study/pages/tab_page.dart';

import '../common_ui/web/webview_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.tab:
        return pageRoute(TabPage(), settings: settings);
      case RoutePath.webViewPage:
        return pageRoute(WebViewPage(loadResource: "", webViewType: WebViewType.URL,), settings: settings);
      case RoutePath.loginPage:
        return pageRoute(const LoginPage(), settings: settings);
      case RoutePath.registerPage:
        return pageRoute(const RegisterPage(), settings: settings);
      case RoutePath.detailKnowledgePage:
        return pageRoute(const KnowledgeDetailTabPage(), settings: settings);
      case RoutePath.searchPage:
        return pageRoute(const SearchPage(), settings: settings);
      case RoutePath.myCollectPage:
        return pageRoute(const MyCollectsPage(), settings: settings);
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
  static const String tab = '/';

  static const String webViewPage = '/web_view_page';

  static const String loginPage = '/login_page';

  static const String registerPage = '/register_page';

  static const String detailKnowledgePage = '/detail_knowledge_page';

  static const String searchPage = '/search_page';

  static const String myCollectPage = '/my_collect_page';
}
