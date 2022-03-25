import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hive_flutter/adapters.dart';

import '../Tool/NoBehavior.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSwitched_hide = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (Hive.box('user_setting').get('no_show_tip_page') != null) {
        isSwitched_hide = Hive.box('user_setting').get('no_show_tip_page');
      } else {
        isSwitched_hide = false;
      }
      
    });
  }

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
        title: Text('기본값 설정', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: makeBody(context, isSwitched_hide),
              ))),
    );
  }
}

// 바디 만들기
Widget makeBody(BuildContext context, bool isSwitched_hide) {
  return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: StatefulBuilder(builder: (_, StateSetter setState) {
        return Column(children: [
          Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Text('광고성 페이지 가리기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black45)),
                    ],
                  )),
              FlutterSwitch(
                activeText: "hide",
                inactiveText: "open",
                valueFontSize: 16.0,
                width: 80,
                borderRadius: 15.0,
                showOnOff: true,
                activeTextColor: Colors.white,
                inactiveTextColor: Colors.red,
                value: isSwitched_hide,
                onToggle: (val) {
                  setState(() {
                    isSwitched_hide = val;
                    //사용자가 이 페이지를 보기 싫어한다는 의미로 로컬에 불린값 저장
                    Hive.box('user_setting')
                        .put('no_show_tip_page', isSwitched_hide);
                  });
                },
              ),
            ],
          )
        ]);
      }));
}
