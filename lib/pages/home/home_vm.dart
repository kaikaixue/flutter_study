import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_study/http/dio_instance.dart';
import 'package:flutter_study/repository/api.dart';

import '../../repository/datas/home_banner_data.dart';
import '../../repository/datas/home_list_data.dart';

class HomeViewModel with ChangeNotifier{
  int pageCount = 0;
  List<HomeBannerData?>? bannerList;
  List<HomeListItemData>? listData = [];

  Future getBanner() async {
    List<HomeBannerData?>? list = await Api.instance.getBanner();
    bannerList = list ?? [];
    notifyListeners();
  }

  Future initListData(bool loadMore, {ValueChanged<bool>? callback}) async {
    if (loadMore) {
      pageCount++;
    } else {
      pageCount = 0;
      listData?.clear();
    }
    getHomeTopList(loadMore).then((topList) {
      if (!loadMore) {
        listData?.addAll(topList ?? []);
      }
      getHomeList(loadMore).then((allList) {
        listData?.addAll(allList ?? []);
        notifyListeners();

        callback?.call(loadMore);
      });
    });
  }

  Future getHomeList(bool loadMore) async {
    List<HomeListItemData>? list = await Api.instance.getHomeList("$pageCount");
    if (list != null && list.isNotEmpty) {
      return list;
    } else {
      if (loadMore && pageCount > 0) {
        pageCount--;
      }
      return [];
    }
  }

  Future<List<HomeListItemData>?> getHomeTopList(bool loadMore) async {
    if (loadMore) {
      return [];
    }
    List<HomeListItemData>? list = await Api.instance.getHomeTopList();
    return list;
  }

  Future collectOrNo(bool isCollect, String? id, int index) async {
    bool? success;
    if (isCollect == true) {
      success = await Api.instance.collect(id);
    } else {
      success = await Api.instance.unCollect(id);
    }
    if (success == true) {
      listData?[index].collect = isCollect;
      notifyListeners();
    } else {

    }
  }
}