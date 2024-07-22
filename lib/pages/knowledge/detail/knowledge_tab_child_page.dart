import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:flutter_study/pages/knowledge/detail/knowledge_detail_vm.dart';
import 'package:flutter_study/pages/knowledge/knowledge_vm.dart';
import 'package:flutter_study/repository/datas/knowledge_detail_list_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common_ui/common_style.dart';
import '../../../common_ui/web/webview_page.dart';
import '../../../common_ui/web/webview_widget.dart';
import '../../../routes/RouteUtils.dart';

class KnowledgeTabChildPage extends StatefulWidget {
  const KnowledgeTabChildPage({super.key, this.cid});

  final String? cid;

  @override
  State<StatefulWidget> createState() {
    return _KnowledgeTabChildPageState();
  }
}

class _KnowledgeTabChildPageState extends State<KnowledgeTabChildPage> {
  KnowledgeDetailViewModel viewModel = KnowledgeDetailViewModel();

  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    viewModel.getDetailList(widget.cid, loadMore).then((value) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Consumer<KnowledgeDetailViewModel>(
        builder: (context, vm, child) {
          return SmartRefreshWidget(
            controller: refreshController,
            onRefresh: () {
              refreshOrLoad(false);
            },
            onLoading: () {
              refreshOrLoad(true);
            },
            child: ListView.builder(
                itemCount: vm.detailList?.length ?? 0,
                itemBuilder: (context, index) {
                  return _item(vm.detailList?[index], onTap: () {
                    RouteUtils.push(
                        context,
                        WebViewPage(
                          loadResource: vm.detailList?[index].link ?? "",
                          webViewType: WebViewType.URL,
                          showTitle: true,
                          title: vm.detailList?[index].title,
                        ));
                  });
                }),
          );
        },
      ),
    );
  }

  Widget _item(KnowledgeDetailItemData? item, {GestureTapCallback? onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 0.5.r)),
            child: Column(children: [
              Row(
                children: [
                  normalText(item?.superChapterName),
                  Expanded(child: SizedBox()),
                  Text("${item?.niceShareDate}"),
                ],
              ),
              Text("${item?.title}", style: titleTextStyle15),
              Row(
                children: [
                  normalText(item?.chapterName),
                  Expanded(child: SizedBox()),
                  Text("${item?.shareUser}"),
                ],
              )
            ])));
  }
}
