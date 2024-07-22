import 'package:flutter/widgets.dart';
import 'package:flutter_study/repository/api.dart';
import 'package:flutter_study/repository/datas/search_list_model.dart';

class SearchViewModel with ChangeNotifier {

    List<SearchListData>? searchList;

    Future search(String? keyword) async {
      searchList = await Api.instance.search(keyWord: keyword);
      notifyListeners();
    }

    void clear() {
      searchList?.clear();
      notifyListeners();
    }
}