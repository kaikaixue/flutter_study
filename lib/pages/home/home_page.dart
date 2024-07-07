import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/datas/home_banner_data.dart';
import 'package:flutter_study/pages/home/home_vm.dart';
import 'package:flutter_study/pages/web_view_page.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:flutter_study/routes/routes.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';

import '../../datas/home_list_data.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.getBanner();
    viewModel.getHomeList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              _banner(),
              _homeListView(),
            ],
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
              return Container(
                height: 150.h,
                width: double.infinity,
                color: Colors.lightBlue,
                child: Image.network(
                  vm.bannerList?[index]?.imagePath ?? "",
                  fit: BoxFit.fill,
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
          return _listItemView(vm.listData?[index]);
        },
        itemCount: vm.listData?.length ?? 0,
      );
    });
  }

  Widget _listItemView(HomeListItemData? item) {
    var name;
    if (item?.author?.isNotEmpty == true) {
      name = item?.author;
    } else {
      name = item?.shareUser;
    }
    return GestureDetector(
        onTap: () {
          RouteUtils.pushForNamed(context, RoutePath.webViewPage,
              arguments: {'name': '使用路由传值'});
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
                  const Text(
                    '置顶',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
              Text(
                item?.title ?? '',
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
                  Image.asset(
                    "assets/images/img_collect_grey.png",
                    width: 30.r,
                    height: 30.r,
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
