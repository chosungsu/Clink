// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/Getx/navibool.dart';
import 'package:clickbyme/Tool/ResponsiveUI.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../BACKENDPART/Auth/GoogleSignInController.dart';
import '../Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Loader.dart';
import '../Tool/TextSize.dart';

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
  final draw = Get.put(navibool());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<navibool>(
      builder: (_) => Scaffold(
        backgroundColor: draw.backgroundcolor,
        body: WillPopScope(
            onWillPop: _onWillPop,
            child: OrientationBuilder(
              builder: ((context, orientation) {
                return Stack(
                  children: [
                    UI(orientation, _ischecked),
                    loading == true
                        ? const Loader(wherein: 'login')
                        : Container()
                  ],
                );
              }),
            )),
      ),
    ));
  }

  Widget UI(Orientation orientation, bool ischecked) {
    return ResponsiveMainUI(
        Row(
          children: [
            Flexible(
                flex: 2,
                child: Center(
                  child: NeumorphicText(
                    'LOGIN',
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: Colors.lightBlue,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                )),
            Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SignInButton(
                        buttonType: ButtonType.google,
                        buttonSize:
                            ButtonSize.medium, // small(default), medium, large
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await GoogleSignInController()
                              .login(context, ischecked);

                          setState(() {
                            loading = false;
                          });
                          Snack.snackbars(
                              context: context,
                              title: '로그인 완료',
                              backgroundcolor: Colors.green,
                              bordercolor: draw.backgroundcolor);
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    Divider(
                      height: 30,
                      color: draw.color_textstatus,
                      thickness: 0.5,
                      indent: 30.0,
                      endIndent: 30.0,
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
                                  children: [
                                    Text(
                                      '(선택)자동 로그인 사용',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: draw.color_textstatus,
                                          letterSpacing: 2),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        widget.first == 'first'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: draw.color_textstatus,
                                            letterSpacing: 2),
                                        text:
                                            '구글로그인(Google Login)을 클릭하여 로그인 시 ',
                                      ),
                                      TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.blue.shade400,
                                            letterSpacing: 2),
                                        text: '앱의 개인정보처리방침',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            var url = Uri.parse(
                                                'https://linkaiteam.github.io/LINKAITEAM/개인정보처리방침');

                                            launchUrl(url);
                                          },
                                      ),
                                      TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: draw.color_textstatus,
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
                )),
          ],
        ),
        Column(
          children: [
            Flexible(
                flex: 2,
                child: Center(
                  child: NeumorphicText(
                    'LOGIN',
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: Colors.lightBlue,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                )),
            Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SignInButton(
                        buttonType: ButtonType.google,
                        buttonSize:
                            ButtonSize.medium, // small(default), medium, large
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await GoogleSignInController()
                              .login(context, ischecked);

                          setState(() {
                            loading = false;
                          });
                          Snack.snackbars(
                              context: context,
                              title: '로그인 완료',
                              backgroundcolor: Colors.green,
                              bordercolor: draw.backgroundcolor);
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    Divider(
                      height: 30,
                      color: draw.color_textstatus,
                      thickness: 0.5,
                      indent: 30.0,
                      endIndent: 30.0,
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
                                  children: [
                                    Text(
                                      '(선택)자동 로그인 사용',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: draw.color_textstatus,
                                          letterSpacing: 2),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        widget.first == 'first'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: draw.color_textstatus,
                                            letterSpacing: 2),
                                        text:
                                            '구글로그인(Google Login)을 클릭하여 로그인 시 ',
                                      ),
                                      TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.blue.shade400,
                                            letterSpacing: 2),
                                        text: '앱의 개인정보처리방침',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            var url = Uri.parse(
                                                'https://linkaiteam.github.io/LINKAITEAM/개인정보처리방침');

                                            launchUrl(url);
                                          },
                                      ),
                                      TextSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: draw.color_textstatus,
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
                )),
          ],
        ),
        orientation);
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

  Widget LoginPlus(BuildContext context, bool ischecked, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '로그인',
          style: TextStyle(
            color: draw.color_textstatus,
            fontSize: 20,
            fontWeight: FontWeight.w600, // bold
          ),
        ),
        SizedBox(
          height: height * 0.25,
        ),
        SignInButton(
            buttonType: ButtonType.google,
            buttonSize: ButtonSize.medium, // small(default), medium, large
            onPressed: () async {
              setState(() {
                loading = true;
              });
              await GoogleSignInController().login(context, ischecked);

              setState(() {
                loading = false;
              });
              Snack.snackbars(
                  context: context,
                  title: '로그인 완료',
                  backgroundcolor: Colors.green,
                  bordercolor: draw.backgroundcolor);
            }),
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
