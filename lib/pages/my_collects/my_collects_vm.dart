import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_study/repository/api.dart';

import '../../repository/datas/my_collects_model.dart';

class MyCollectsViewModel with ChangeNotifier {
  List<MyCollectItemModel>? dataList = [];

  int _pageCount = 0;

  Future getMyCollectList(bool loadMore) async {
    if (loadMore) {
      _pageCount ++;
    } else {
      _pageCount = 0;
      dataList?.clear();
    }
    var list = await Api.instance.getMyCollectList("$_pageCount");
    if (list != null && list.isNotEmpty == true) {
      dataList?.addAll(list);
      notifyListeners();
    } else {
      if (loadMore && _pageCount > 0) {
        _pageCount --;
      }
    }
  }

  Future cancelCollect(int index, String? id) async{
    bool? success = await Api.instance.unCollect(id);
    if (success == true) {
      try {
        dataList?.remove(dataList?[index]);
        notifyListeners();
      } catch (e) {
      }
    }
  }

}