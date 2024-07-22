import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_study/pages/search/search_vm.dart';
import 'package:flutter_study/routes/RouteUtils.dart';
import 'package:provider/provider.dart';

import '../../common_ui/web/webview_page.dart';
import '../../common_ui/web/webview_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.keyword});

  final String? keyword;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController inputController;
  SearchViewModel viewModel = SearchViewModel();

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController(text: widget.keyword ?? '');
    viewModel.search(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _searchBar(onBack: () {
                RouteUtils.pop(context);
              }, onCancel: () {
                inputController.text = "";
                viewModel.clear();
              }, onSubmitted: (value) {
                viewModel.search(value);
                // 隐藏软键盘 两种方式
                // SystemChannels.textInput.invokeMethod("TextInput.hide");
                FocusScope.of(context).unfocus();
              }),
              Consumer<SearchViewModel>(builder: (context, vm, child) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: vm.searchList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _listItem(vm.searchList?[index].title, () {
                            RouteUtils.push(
                                context,
                                WebViewPage(
                                  loadResource: vm.searchList?[index].link ?? "",
                                  webViewType: WebViewType.URL,
                                  showTitle: true,
                                  title: vm.searchList?[index].title,
                                ));
                          });
                        }));
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(String? title, GestureTapCallback? onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.r, color: Colors.black12))),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Html(
            data: title ?? '',
            style: {'html': Style(fontSize: FontSize(15.sp))},
          ),
        ));
  }

  Widget _searchBar(
      {GestureTapCallback? onBack,
      GestureTapCallback? onCancel,
      ValueChanged<String>? onSubmitted}) {
    return Container(
      color: Colors.teal,
      height: 50.h,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          GestureDetector(
            onTap: onBack,
            child: Image.asset(
              "assets/images/icon_back.png",
              width: 35.r,
              height: 35.r,
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(6.r),
            child: TextField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              controller: inputController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 10.w),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15.r)))),
            ),
          )),
          SizedBox(
            width: 5.w,
          ),
          GestureDetector(
            onTap: onCancel,
            child: Text(
              '取消',
              style: TextStyle(fontSize: 13.sp, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
    );
  }
}
