import 'package:clickbyme/LocalNotiPlatform/NotificationApi.dart';
import 'package:clickbyme/sheets/userinfo_draggable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Loader.dart';
import '../Tool/TextSize.dart';
import '../UI/Home/Widgets/CreateCalandmemo.dart';
import '../initScreenLoading.dart';
import '../route.dart';

class LoginSignPage extends StatefulWidget {
  const LoginSignPage({Key? key, required this.first}) : super(key: key);
  final String first;
  @override
  State<StatefulWidget> createState() => _LoginSignPageState();
}

class _LoginSignPageState extends State<LoginSignPage>
    with WidgetsBindingObserver {
  bool _ischecked = false;
  bool loading = false;
  late FToast fToast;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                makeBody(context, _ischecked),
                const Divider(
                  height: 30,
                  color: Colors.grey,
                  thickness: 0.5,
                  indent: 30.0,
                  endIndent: 30.0,
                ),
                const Text(
                  '동의항목',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold, // bold
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: _ischecked,
                            onChanged: (value) {
                              setState(() {
                                _ischecked = value!;
                              });
                            }),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: const [
                                Text(
                                  '(선택)자동 로그인 사용',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black,
                                      letterSpacing: 2),
                                ),
                              ],
                            ))
                      ],
                    ),
                    widget.first == 'first'
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black,
                                        letterSpacing: 2),
                                    text: '구글로그인(Google Login)을 클릭하여 로그인 시 ',
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.blue.shade400,
                                        letterSpacing: 2),
                                    text: '앱의 개인정보처리방침',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        userinfo_draggable(context);
                                      },
                                  ),
                                  const TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black,
                                        letterSpacing: 2),
                                    text: '에 동의하는 것으로 간주합니다.',
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                )
              ],
            ),
            loading == true ? const Loader(wherein: 'login') : Container()
          ],
        ),
      ),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context, bool ischecked) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: height * 0.75,
            child: LoginPlus(context, ischecked, height),
          ),
        ],
      ),
    );
  }

  LoginPlus(BuildContext context, bool ischecked, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '간단 소셜 로그인',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.w600, // bold
          ),
        ),
        SizedBox(
          height: height * 0.25,
        ),
        InkWell(
            onTap: () async {
              /*await Provider.of<GoogleSignInController>(context, listen: false)
                  .login(context, ischecked);*/
              setState(() {
                loading = true;
              });
              await GoogleSignInController().login(context, ischecked);
              setState(() {
                loading = false;
              });
              CreateCalandmemoSuccessFlushbar('로그인완료', fToast);
              /*await Navigator.of(context).pushReplacement(
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: const MyHomePage(
                    index: 1,
                  ),
                ),
              );
              Hive.box('user_setting').put('page_index', 1);*/
            },
            child: SizedBox(
              width: 200 * (MediaQuery.of(context).size.width / 392),
              height: 50,
              child: Image.asset(
                'assets/images/google_signin.png',
                fit: BoxFit.fitWidth,
              ),
            )),
        /*const SizedBox(
        height: 10,
      ),
      InkWell(
          onTap: () async {
            await Provider.of<KakaoSignInController>(context, listen: false)
                .login(context, ischecked);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(
                  index: 0,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 200 * (MediaQuery.of(context).size.width / 392),
            height: 50,
            child: Image.asset(
              'assets/images/kakao_login_medium_wide.png',
              fit: BoxFit.fitWidth,
            ),
          )),*/
      ],
    );
  }

  Future<bool> _onWillPop() async {
    return await Get.dialog(OSDialog(
            context,
            '종료',
            Text('앱을 종료하시겠습니까?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            pressed1)) ??
        false;
  }
}
