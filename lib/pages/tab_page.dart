import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/common_ui/navigation/navigation_bar_widget.dart';
import 'package:flutter_study/pages/home/home_page.dart';
import 'package:flutter_study/pages/hot_key/hot_key_page.dart';
import 'package:flutter_study/pages/knowledge/knowledge_page.dart';
import 'package:flutter_study/pages/personal/personal_page.dart';

class TabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> {
  late List<Widget> pages;

  late List<String> labels;

  late List<Widget> icons;

  late List<Widget> activeIcons;

  @override
  void initState() {
    super.initState();
    initTabData();
  }

  void initTabData() {
    pages = [HomePage(), HotKeyPage(), KnowledgePage(), PersonalPage()];

    labels = ["首页", "热点", "体系", "我的"];

    icons = [
      Image.asset(
        "assets/images/icon_home_grey.png",
        width: 32.r,
        height: 32.h,
      ),
      Image.asset(
        "assets/images/icon_hot_key_grey.png",
        width: 32.r,
        height: 32.h,
      ),
      Image.asset(
        "assets/images/icon_knowledge_grey.png",
        width: 32.r,
        height: 32.h,
      ),
      Image.asset(
        "assets/images/icon_personal_grey.png",
        width: 32.r,
        height: 32.h,
      )
    ];

    activeIcons = [
      Image.asset(
        "assets/images/icon_home_selected.png",
        width: 32.r,
        height: 32.h,
      ),
      Image.asset(
        "assets/images/icon_hot_key_selected.png",
        width: 32.r,
        height: 32.h,
      ),
      Image.asset(
        "assets/images/icon_knowledge_selected.png",
        width: 32.r,
        height: 32.h,
      ),
      Image.asset(
        "assets/images/icon_personal_selected.png",
        width: 32.r,
        height: 32.h,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
        pages: pages,
        labels: labels,
        icons: icons,
        activeIcons: activeIcons,
        onTabChange: (index) {
          print(index);
        });
  }
}
