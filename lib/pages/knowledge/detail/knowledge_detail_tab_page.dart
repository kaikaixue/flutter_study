import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/pages/knowledge/detail/knowledge_detail_vm.dart';
import 'package:flutter_study/pages/knowledge/detail/knowledge_tab_child_page.dart';
import 'package:flutter_study/repository/datas/knowledge_list_data.dart';
import 'package:provider/provider.dart';

class KnowledgeDetailTabPage extends StatefulWidget {
  const KnowledgeDetailTabPage({super.key, this.tabList});

  final List<Children>? tabList;

  @override
  State<StatefulWidget> createState() {
    return _KnowledgeDetailTabPageState();
  }
}

class _KnowledgeDetailTabPageState extends State<KnowledgeDetailTabPage>
    with SingleTickerProviderStateMixin {
  KnowledgeDetailViewModel viewModel = KnowledgeDetailViewModel();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    viewModel.initTabs(widget.tabList);
    tabController =
        TabController(length: widget.tabList?.length ?? 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: viewModel.tabs,
            controller: tabController,
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            isScrollable: true,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: tabController,
            children: children(),
          ),
        ),
      ),
    );
  }

  List<Widget> children() {
    return widget.tabList?.map((e) {
          return KnowledgeTabChildPage(cid: "${e.id  ?? ''}",);
        }).toList() ??
        [];
  }
}
