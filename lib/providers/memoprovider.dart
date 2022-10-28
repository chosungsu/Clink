import 'dart:collection';
import 'dart:convert';
import 'package:get/get.dart';
import '../DB/MemoList.dart';
import 'package:http/http.dart' as http;

class memoprovider extends GetxController {
  List<MemoList> memolist = [];
  UnmodifiableListView<MemoList> get allmemo => UnmodifiableListView(memolist);
  fetchMemos() async {
    final response = await http.get(Uri.parse('http://localhost:8000/memo'));
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      memolist = data.map<MemoList>((json) => MemoList.fromJason(json));
    }
    notifyChildrens();
  }
}
