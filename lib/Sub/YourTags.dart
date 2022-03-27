import 'package:clickbyme/DB/ChipList.dart';
import 'package:clickbyme/DB/Recommend.dart';
import 'package:clickbyme/Tool/Shimmer_Chip.dart';
import 'package:clickbyme/sheets/addChips.dart';
import 'package:clickbyme/Futures/chipasync.dart';
import 'package:clickbyme/Tool/Chips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import '../DB/AD_Home.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/Shimmer_DayLog.dart';

class YourTags extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _YourTagsState();
}

class _YourTagsState extends State<YourTags> with TickerProviderStateMixin {
  late TabController _tabController_tags;
  late TextEditingController _eventController;
  int tabindex = 0;
  bool isselectedchip = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController_tags =
        TabController(length: 2, vsync: this, initialIndex: tabindex);
    _eventController = TextEditingController();
  }

  /*@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventController.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black54,
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              color: Colors.black54,
              tooltip: '추가하기',
              onPressed: () => {
                //bottomsheet 사용하기
                addChips(context, _eventController)
              },
              icon: const Icon(Icons.add_circle),
            ),
          ],
          title: Text('태그 관리', style: TextStyle(color: Colors.blueGrey)),
          elevation: 0,
        ),
        body: ScrollConfiguration(
            behavior: NoBehavior(),
            child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                    child: makeBody(context, _tabController_tags,
                        _eventController, isselectedchip)))));
  }
}

// 바디 만들기
Widget makeBody(BuildContext context, TabController tabController_tags,
    TextEditingController eventController, bool isselectedchip) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final List<Recommend> _list_content = [
    Recommend(sub: '추천 태그'),
    Recommend(sub: '사용자의 태그 보관함'),
    Recommend(sub: '분석'),
  ];
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '0',
      title: '데이로그 관리 탭이 신설되었습니다.',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '1',
      title: '챌린지 관리 탭이 신설되었습니다.',
      person_num: 4,
      date: DateTime.now(),
    ),
  ];
  return Column(
      children: [
      Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Row(
                children: const [
                  Text('클립 선택',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45)),
                ],
              )),
        ],
      ),
      FutureBuilder<List<ChipList>>(
        future: chipasync(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ChipList>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ChipRow(
                context, isselectedchip, snapshot.data!, eventController);
          } else {
            return Shimmer_Chip(context);
          }
        },
      ),
    ]);
}

ChipRow(BuildContext context, selected, List<ChipList> list,
    TextEditingController eventController) {
  List<ChipList> tmp_title_chip_list = [];
  return SizedBox(
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            list.isNotEmpty
                ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        width: 150,
                        child: Chips(list[index].title, list[index].first_word,
                            Colors.green, selected, eventController),
                      );
                    }),
                )
                : SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Hive.box('user_info').get('id').toString() +
                              '님 \n' +
                              '관심태그가 아직 없네요..',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ))
          ],
        ),
      ));
}
