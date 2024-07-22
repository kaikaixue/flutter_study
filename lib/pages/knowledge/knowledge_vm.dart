import 'package:flutter/widgets.dart';
import 'package:flutter_study/repository/datas/knowledge_list_data.dart';

import '../../repository/api.dart';

class KnowledgeViewModel with ChangeNotifier {
  List<KnowledgeListData?>? list;
  Future knowledgeList() async {
    list = await Api.instance.knowledgeList();
    notifyListeners();
  }

  String generalChildNames(List<Children?>? children) {
    var names = StringBuffer();
    children?.forEach((el){
      names.write("${el?.name} ");
    });
    return names.toString();
  }
}