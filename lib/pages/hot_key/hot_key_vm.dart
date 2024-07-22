import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_study/repository/api.dart';

import '../../repository/datas/common_website_data.dart';
import '../../repository/datas/search_hot_keys_data.dart';

class HotKeyViewModel with ChangeNotifier {
  List<CommonWebsiteData>? websiteList;

  List<SearchHotKeysData>? keyList;

  Future initData() async {
    getWebsiteList().then((value) {
      getSearchHotKeysList().then((value) {
        notifyListeners();
      });
    });
  }

  Future getWebsiteList() async {
    websiteList = await Api.instance.getWebsiteList();
  }

  Future getSearchHotKeysList() async {
    keyList = await Api.instance.getSearchHotKeysList();
  }
}
