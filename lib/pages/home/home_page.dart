import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/common_ui/loading.dart';
import 'package:flutter_study/common_ui/web/webview_page.dart';
import 'package:flutter_study/common_ui/web/webview_widget.dart';
import 'package:flutter_study/pages/home/home_vm.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:flutter_study/routes/routes.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common_ui/smart_refresh/smart_refresh_widget.dart';
import '../../repository/datas/home_list_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel = HomeViewModel();
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
    viewModel.getBanner();
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    viewModel.initListData(loadMore, callback: (loadMore) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
      Loading.dismissAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
            child: SmartRefreshWidget(
          controller: refreshController,
          onLoading: () {
            refreshOrLoad(true);
          },
          onRefresh: () {
            viewModel.getBanner().then((value) {
              refreshOrLoad(false);
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _banner(),
                _homeListView(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _banner() {
    return Consumer<HomeViewModel>(builder: (context, vm, child) {
      return SizedBox(
        width: double.infinity,
        height: 150.h,
        child: Swiper(
            itemCount: vm.bannerList?.length ?? 0,
            indicatorLayout: PageIndicatorLayout.NONE,
            autoplay: true,
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  RouteUtils.push(
                      context,
                      WebViewPage(
                        loadResource: vm.bannerList?[index]?.url ?? "",
                        webViewType: WebViewType.URL,
                        showTitle: true,
                        title: vm.bannerList?[index]?.title ?? "",
                      ));
                },
                child:
                Container(
                  height: 150.h,
                  width: double.infinity,
                  color: Colors.lightBlue,
                  child: Image.network(
                    vm.bannerList?[index]?.imagePath ?? "",
                    fit: BoxFit.fill,
                  ),
                ),
              );
            }),
      );
    });
  }

  Widget _homeListView() {
    return Consumer<HomeViewModel>(builder: (context, vm, child) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _listItemView(vm.listData?[index], index);
        },
        itemCount: vm.listData?.length ?? 0,
      );
    });
  }

  Widget _listItemView(HomeListItemData? item, int index) {
    var name;
    if (item?.author?.isNotEmpty == true) {
      name = item?.author;
    } else {
      name = item?.shareUser;
    }
    return GestureDetector(
        onTap: () {
          RouteUtils.push(
              context,
              WebViewPage(
                loadResource: item?.link ?? "",
                webViewType: WebViewType.URL,
                showTitle: true,
                title: item?.title,
              ));
        },
        child: Container(
          height: 120.h,
          width: double.infinity,
          margin:
              EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w, right: 10.w),
          padding:
              EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w, right: 10.w),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: 0.5.r,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.network(
                      width: 30.r,
                      height: 30.r,
                      "https://xuekaikai.oss-cn-shanghai.aliyuncs.com/campus_navigatic/rS3Ap2ChSzx.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text(item?.niceShareDate ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                  ),
                  SizedBox(width: 5.w),
                  (item?.type?.toInt() == 1)
                      ? const Text(
                          '置顶',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                item?.title ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
              ),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  Text(
                    item?.chapterName ?? '',
                    style: TextStyle(color: Colors.green, fontSize: 12.sp),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      if (item?.collect == true) {
                        viewModel.collectOrNo(false, "${item?.id}", index);
                      } else {
                        viewModel.collectOrNo(true, "${item?.id}", index);
                      }
                    },
                    child: Image.asset(
                      item?.collect == true
                          ? "assets/images/img_collect.png"
                          : "assets/images/img_collect_grey.png",
                      width: 30.r,
                      height: 30.r,
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
