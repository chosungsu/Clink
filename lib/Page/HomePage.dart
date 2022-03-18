import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserSubscription.dart';
import 'package:clickbyme/UI/UserTips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../DB/AD_Home.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Sub/WritePost.dart';
import '../Tool/NoBehavior.dart';
import '../UI/AD.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int tabindex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _tabController.addListener(() {
        setState(() {
          tabindex = _tabController.index;
        });
      });
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        title: Text(widget.title,
            style: TextStyle(
              color: Colors.deepPurpleAccent.shade100,
            )),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () => {
              //bottomsheet 사용하기
              _onAddPressed(context),
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserTips(context),
                AD(context),
                UserSubscription(context, _tabController, tabindex),
              ],
            ),
          )),
    );
  }

  _onAddPressed(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 120,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.add_link_rounded),
                  title: const Text('관심태그 추가'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.upload_rounded),
                  title: const Text('업로드'),
                  onTap: () => {
                    //이전 바텀시트 제거 후 스택 새로 쌓기
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WritePost()),
                    ),
                  },
                ),
              ],
            ),
          );
        });
  }
}
