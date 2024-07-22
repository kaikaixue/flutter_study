import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/common_ui/common_style.dart';
import 'package:flutter_study/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:flutter_study/common_ui/web/webview_page.dart';
import 'package:flutter_study/common_ui/web/webview_widget.dart';
import 'package:flutter_study/pages/home/home_vm.dart';
import 'package:flutter_study/pages/my_collects/my_collects_vm.dart';
import 'package:flutter_study/repository/datas/my_collects_model.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCollectsPage extends StatefulWidget {
  const MyCollectsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyCollectsPageState();
  }
}

class _MyCollectsPageState extends State<MyCollectsPage> {
  MyCollectsViewModel viewModel = MyCollectsViewModel();
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    viewModel.getMyCollectList(false);
  }

  void refreshOrLoad(bool loadMore) {
    viewModel.getMyCollectList(loadMore).then((value) {
      if (loadMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(child: Consumer<MyCollectsViewModel>(
          builder: (context, vm, child) {
            return SmartRefreshWidget(
                onRefresh: () {
                  refreshOrLoad(false);
                },
                onLoading: () {
                  refreshOrLoad(true);
                },
                controller: _refreshController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _collectItem(vm.dataList?[index], onTap: () {
                      viewModel.cancelCollect(
                          index, "${vm.dataList?[index].id}");
                    }, itemClick: () {
                      RouteUtils.push(
                          context,
                          WebViewPage(
                            loadResource: vm.dataList?[index].link ?? "",
                            webViewType: WebViewType.URL,
                            showTitle: true,
                            title: vm.dataList?[index].title,
                          ));
                    });
                  },
                  itemCount: vm.dataList?.length ?? 0,
                ));
          },
        )),
      ),
    );
  }

  Widget _collectItem(MyCollectItemModel? item,
      {GestureTapCallback? itemClick, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: itemClick,
      child: Container(
        margin: EdgeInsets.all(10.r),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text("作者： ${item?.author}")),
                Text('时间：${item?.niceDate}')
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              '${item?.title}',
              style: titleTextStyle15,
            ),
            Row(
              children: [
                Expanded(child: Text('分类：${item?.chapterName}')),
                collectImage(true, onTap: onTap)
              ],
            )
          ],
        ),
      ),
    );
  }
}
