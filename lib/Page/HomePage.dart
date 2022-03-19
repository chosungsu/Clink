import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserSubscription.dart';
import 'package:clickbyme/UI/UserTips.dart';
import 'package:flutter/material.dart';
import '../Tool/NoBehavior.dart';
import '../UI/AD.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;
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
      if (_tabController != null) {
        _tabController!.addListener(() {
          setState(() {
            tabindex = _tabController!.index;
          });
        });
      }
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
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserTips(context),
                AD(context),
                UserPicks(context),
                UserSubscription(context, _tabController!, tabindex),
              ],
            ),
          )),
    );
  }
}
