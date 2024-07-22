import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/repository/api.dart';

import '../../../repository/datas/knowledge_detail_list_data.dart';
import '../../../repository/datas/knowledge_list_data.dart';

class KnowledgeDetailViewModel with ChangeNotifier {
  List<Tab> tabs = [];
  List<KnowledgeDetailItemData>? detailList = [];

  int _pageCount = 0;

  void initTabs(List<Children>? tabList) {
    tabList?.forEach((el) {
      tabs.add(Tab(text: el.name ?? ''));
    });
  }

  Future getDetailList(String? cid, bool loadMore) async {
    if (loadMore) {
      _pageCount ++;
    } else {
      _pageCount = 0;
      detailList?.clear();
    }
    var list = await Api.instance.detailKnowledgeList('$_pageCount', cid);
    if (list?.isNotEmpty == true) {
      detailList?.addAll(list ?? []);
      notifyListeners();
    } else {
      if (loadMore && _pageCount > 0) {
         _pageCount --;
      }
    }
  }
}
