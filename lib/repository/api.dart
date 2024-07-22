import 'package:dio/dio.dart';
import 'package:flutter_study/repository/datas/auth_data.dart';
import 'package:flutter_study/repository/datas/common_website_data.dart';
import 'package:flutter_study/repository/datas/my_collects_model.dart';
import 'package:flutter_study/repository/datas/search_hot_keys_data.dart';

import '../http/dio_instance.dart';
import 'datas/home_banner_data.dart';
import 'datas/home_list_data.dart';
import 'datas/knowledge_detail_list_data.dart';
import 'datas/knowledge_list_data.dart';
import 'datas/search_list_model.dart';

class Api {
  static Api instance = Api._();

  Api._();

  Future<List<HomeBannerData?>?> getBanner() async {
    Response response = await DioInstance.instance().get(path: '/banner/json');
    HomeBannerListData bannerData = HomeBannerListData.fromJson(response.data);
    return bannerData.bannerList;
  }

  Future<List<HomeListItemData>?> getHomeList(String pageCount) async {
    Response response = await DioInstance.instance().get(path: '/article/list/$pageCount/json');
    HomeListData homeData = HomeListData.fromJson(response.data);
    return homeData.datas;
  }

  Future<List<HomeListItemData>?> getHomeTopList() async {
    Response response = await DioInstance.instance().get(path: '/article/top/json');
    HomeTopListData homeTopData = HomeTopListData.fromJson(response.data);
    return homeTopData.topList;
  }

  Future<List<CommonWebsiteData>?> getWebsiteList() async {
    Response response = await DioInstance.instance().get(path: '/friend/json');
    CommonWebsiteListData websiteListData = CommonWebsiteListData.fromJson(response.data);
    return websiteListData.websiteList;
  }

  Future<List<SearchHotKeysData>?> getSearchHotKeysList() async {
    Response response = await DioInstance.instance().get(path: '/hotkey/json');
    SearchHotKeysListData searchHotKeysListData = SearchHotKeysListData.fromJson(response.data);
    return searchHotKeysListData.keyList;
  }

  Future<dynamic> register({String? name, String? password, String? rePassword}) async {
    Response response = await DioInstance.instance().post(path: '/user/register', queryParameters: {
      "username": name,
      "password": password,
      "repassword": rePassword,
    });
    return response.data;
  }

  Future<AuthData> login({String? name, String? password}) async {
    Response response = await DioInstance.instance().post(path: '/user/login', queryParameters: {
      "username": name,
      "password": password,
    });
    return AuthData.fromJson(response.data);
  }

  Future<bool?> logout() async {
    Response response = await DioInstance.instance().get(path: '/user/logout/json');
    return boolCallback(response.data);
  }

  Future<List<KnowledgeListData?>?> knowledgeList({String? name, String? password}) async {
    Response response = await DioInstance.instance().get(path: '/tree/json');
    KnowledgeData knowledgeData = KnowledgeData.fromJson(response.data);
    return knowledgeData.list;
  }

  Future<bool?> collect(String? id) async {
    Response response = await DioInstance.instance().post(path: '/lg/collect/$id/json');
    return boolCallback(response.data);
  }

  Future<bool?> unCollect(String? id) async {
    Response response = await DioInstance.instance().post(path: '/lg/uncollect_originId/$id/json');
    return boolCallback(response.data);
  }

  Future<List<KnowledgeDetailItemData>?> detailKnowledgeList(String? pageCount, String? cid) async {
    Response response = await DioInstance.instance().get(path: '/article/list/$pageCount/json', params: {"cid": cid});
    var knowledgeDetailList = KnowledgeDetailListData.fromJson(response.data);
    return knowledgeDetailList.datas;
  }

  ///搜索
  Future<List<SearchListData>?> search({String? keyWord}) async {
    Response rsp = await DioInstance.instance()
        .post(path: "article/query/0/json", queryParameters: {"k": keyWord});
    SearchData? model = SearchData.fromJson(rsp.data);
    if (model.datas != null && model.datas?.isNotEmpty == true) {
      return model.datas;
    }
    return [];
  }

  /// 我的收藏
  Future<List<MyCollectItemModel>?> getMyCollectList(String? pageCount) async {
    Response response = await DioInstance.instance().get(path: "/lg/collect/list/$pageCount/json");
    MyCollectsModel myCollectsModel = MyCollectsModel.fromJson(response.data);
    return myCollectsModel.datas;
  }



  bool? boolCallback(dynamic data) {
    if (data != null && data is bool) {
      return data;
    }
    return false;
  }
}