import 'dart:async';

import 'package:clickbyme/UI/UserDetails.dart';
import 'package:clickbyme/UI/UserSettings.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/checkId.dart';
import '../Tool/NoBehavior.dart';
import '../UI/NoticeApps.dart';
import '../route.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool login_state = false;
  String name = "null", email = "null", cnt = "null";
  int current_noticepage = 0;
  late Timer _timer_noti;
  PageController _pcontroll = PageController(
    initialPage: 0,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        checkId(context);
      });
    });
    _timer_noti = Timer.periodic(Duration(seconds: 2), (timer) {
      if (current_noticepage < 4) {
        current_noticepage++;
      } else {
        current_noticepage = 0;
      }
      _pcontroll.animateToPage(current_noticepage,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer_noti.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ProfileBody(context, _pcontroll),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}

Widget ProfileBody(BuildContext context, PageController pcontroll) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ScrollConfiguration(
      behavior: NoBehavior(),
      child: SingleChildScrollView(
          child: Column(children: <Widget>[
        UserDetails(context),
        NoticeApps(context, pcontroll),
        UserSettings(context),
      ])),
    );
  });
}

DeleteUserVerify(BuildContext context, String name) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(children: [
            const Text(
              '회원탈퇴',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 22,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '회원탈퇴 진행하겠습니까?\n'
              '아래 버튼을 클릭하시면 회원탈퇴처리가 완료됩니다.\n'
              '더 좋은 서비스로 다음 기회에 찾아뵙겠습니다.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                //탈퇴 로직 구현
                Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const MyHomePage(title: 'HabitMind'),
                  ),
                );
                Provider.of<GoogleSignInController>(context, listen: false)
                    .logout(context, name);
                Provider.of<KakaoSignInController>(context, listen: false)
                    .logout(context, name);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0),
              child: const Text(
                '탈퇴하기',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
            ),
          ]),
        );
      });
}
