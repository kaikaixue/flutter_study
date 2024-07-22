import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/common_ui/web/webview_widget.dart';
import 'package:flutter_study/pages/hot_key/hot_key_vm.dart';
import 'package:flutter_study/pages/search/search_page.dart';
import 'package:flutter_study/repository/datas/home_list_data.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:flutter_study/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../common_ui/web/webview_page.dart';
import '../../repository/datas/common_website_data.dart';
import '../../repository/datas/search_hot_keys_data.dart';

class HotKeyPage extends StatefulWidget {
  const HotKeyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HotKeyPageState();
  }
}

/// 常用网站Item回调
typedef WebsiteClick = Function(String name, String link);

class _HotKeyPageState extends State<HotKeyPage> {
  HotKeyViewModel viewModel = HotKeyViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
        child: Expanded(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 6.h, bottom: 6.h),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 0.5.r, color: Colors.grey),
                      bottom: BorderSide(width: 0.5.r, color: Colors.grey))),
              child: Row(children: [
                Text(
                  "搜索热词",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    RouteUtils.push(context, const SearchPage());
                  },
                  child: Image.asset(
                    "assets/images/icon_search.png",
                    width: 30.r,
                    height: 30.r,
                  ),
                )
              ]),
            ),
            Consumer<HotKeyViewModel>(builder: (context, vm, child) {
              return _gridView(false, keyList: vm.keyList, itemTap: (value) {
                RouteUtils.push(
                    context,
                    SearchPage(
                      keyword: value,
                    ));
              });
            }),
            Container(
              margin: EdgeInsets.only(top: 20.h),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 13.h, bottom: 13.h),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 0.5.r, color: Colors.grey),
                      bottom: BorderSide(width: 0.5.r, color: Colors.grey))),
              child: Row(children: [
                Text(
                  "常用网站",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
              ]),
            ),
            Consumer<HotKeyViewModel>(builder: (context, vm, child) {
              return _gridView(true, websiteList: vm.websiteList,
                  websiteClick: (name, link) {
                RouteUtils.push(
                    context,
                    WebViewPage(
                      loadResource: link,
                      webViewType: WebViewType.URL,
                      showTitle: true,
                      title: name,
                    ));
              });
            }),
          ],
        )),
      ))),
    );
  }

  Widget _gridView(bool? isWebsite,
      {List<CommonWebsiteData>? websiteList,
      List<SearchHotKeysData>? keyList,
      ValueChanged<String>? itemTap,
      WebsiteClick? websiteClick}) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 8.r,
            mainAxisSpacing: 10.r,
            maxCrossAxisExtent: 120.w,
            childAspectRatio: 3),
        itemBuilder: (context, index) {
          if (isWebsite == true) {
            return _item(
                name: websiteList?[index].name,
                itemTap: itemTap,
                link: websiteList?[index].link,
                websiteClick: websiteClick);
          } else {
            return _item(name: keyList?[index].name, itemTap: itemTap);
          }
        },
        itemCount:
            isWebsite == true ? websiteList?.length ?? 0 : keyList?.length ?? 0,
      ),
    );
  }

  Widget _item(
      {String? name,
      ValueChanged<String>? itemTap,
      String? link,
      WebsiteClick? websiteClick}) {
    return GestureDetector(
      onTap: () {
        if (link != null) {
          websiteClick?.call(name ?? "", link);
          itemTap?.call(link);
        } else {
          itemTap?.call(name ?? '');
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5.r),
            borderRadius: BorderRadius.circular(10.r)),
        child: Text(name ?? ''),
      ),
    );
  }
}
