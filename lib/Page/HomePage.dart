import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserSubscription.dart';
import 'package:flutter/material.dart';
import '../DB/AD_Home.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Sub/WritePost.dart';
import '../Tool/NoBehavior.dart';
import '../UI/AD.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  ScrollController _mainController = ScrollController();
  ScrollController _subController = ScrollController();
  double _removableSize = 300;
  bool _isStickyOnTop = false;
  final List<AD_Home> _list_subscript = [
    AD_Home(
      id: '1',
      title: '일정 관리',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '인맥 관리',
      person_num: 4,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '구독 관리',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '포인트 관리',
      person_num: 5,
      date: DateTime.now(),
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainController.addListener(() {
      if (_mainController.offset >= _removableSize && !_isStickyOnTop) {
        _isStickyOnTop = true;
        setState(() {

        });
      } else if (_mainController.offset < _removableSize && !_isStickyOnTop) {
        _isStickyOnTop = false;
        setState(() {

        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        title: Text(
            'SuChip',
            style: TextStyle(
                color: Colors.deepPurpleAccent.shade100,
            )
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () =>
            {
              //bottomsheet 사용하기
              _onAddPressed(context),
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      AD(context),
                      UserSubscription(context, _mainController,
                          _subController, _isStickyOnTop, _list_subscript),
                    ],
                  ),
                ),
              );
            })
      ),

    );
  }
  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }

  _onAddPressed(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        height: 120,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add_link_rounded),
              title: const Text('관심태그 추가'),
              onTap: () => {

              },
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
