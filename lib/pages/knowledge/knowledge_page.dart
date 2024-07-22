import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:flutter_study/pages/knowledge/detail/knowledge_detail_tab_page.dart';
import 'package:flutter_study/pages/knowledge/knowledge_vm.dart';
import 'package:flutter_study/repository/datas/knowledge_list_data.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _KnowledgePageState();
  }
}

class _KnowledgePageState extends State<KnowledgePage> {
  KnowledgeViewModel viewModel = KnowledgeViewModel();
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    viewModel.knowledgeList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(body: SafeArea(child: Consumer<KnowledgeViewModel>(
        builder: (context, vm, child) {
          return SmartRefreshWidget(
            enablePullUp: false,
            controller: _refreshController,
            child: knowledgeListview(),
            onRefresh: () {
              viewModel.knowledgeList().then((value) {
                _refreshController.refreshCompleted();
              });
            },
          );
        },
      ))),
    );
  }

  Widget knowledgeListview() {
    return Consumer<KnowledgeViewModel>(builder: (context, value, child) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.list?.length ?? 0,
          itemBuilder: (context, index) {
            return knowledgeItem(value.list?[index]);
          });
    });
  }

  Widget knowledgeItem(KnowledgeListData? item) {
    return GestureDetector(
        onTap: () {
          RouteUtils.push(context, KnowledgeDetailTabPage(tabList: item?.children));
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 0.5.r),
                borderRadius: BorderRadius.all(Radius.circular(5.r))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          item?.name ?? "",
                          style: TextStyle(color: Colors.black, fontSize: 15.sp),
                        ),
                        SizedBox(height: 10.h),
                        Text(viewModel.generalChildNames(item?.children)),
                      ])),
                  Image.asset("assets/images/img_arrow_right.png",
                      height: 24.r, width: 24.r)
                ])));
  }
}
