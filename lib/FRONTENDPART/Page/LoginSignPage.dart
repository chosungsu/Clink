// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/Getx/navibool.dart';
import 'package:clickbyme/Tool/ResponsiveUI.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BACKENDPART/Auth/GoogleSignInController.dart';
import '../Route/subuiroute.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/Loader.dart';
import '../../Tool/TextSize.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
        LandScapeView(ischecked), PortraitView(ischecked), orientation);
  }

  LandScapeView(bool ischecked) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Row(
        children: [
          const Flexible(
              flex: 3,
              child: Center(
                child: Icon(
                  Ionicons.lock_closed,
                  size: 50,
                  color: Colors.blue,
                ),
              )),
          Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: 80.w,
                        child: Row(children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              height: 0,
                              color: TextColor_shadowcolor(),
                            ),
                          ),
                          Text(
                            'Social Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 30,
                                color: draw.color_textstatus,
                                letterSpacing: 2),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              height: 0,
                              color: TextColor_shadowcolor(),
                            ),
                          ),
                        ]),
                      )),
                  Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SignInButton(
                                  width: 80.w,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(
                                        color: TextColor_shadowcolor()),
                                  ),
                                  elevation: 0,
                                  btnColor: BGColor_shadowcolor(),
                                  buttonType: ButtonType.google,
                                  buttonSize: ButtonSize
                                      .medium, // small(default), medium, large
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
                              const SizedBox(
                                height: 20,
                              ),
                              SignInButton(
                                  width: 80.w,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(
                                        color: TextColor_shadowcolor()),
                                  ),
                                  elevation: 0,
                                  btnColor: BGColor_shadowcolor(),
                                  buttonType: ButtonType.apple,
                                  buttonSize: ButtonSize
                                      .medium, // small(default), medium, large
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
                            ],
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
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
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
                      ))
                ],
              )),
          const Flexible(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }

  PortraitView(bool ischecked) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          const Flexible(
              flex: 1,
              child: Center(
                child: Icon(
                  Ionicons.lock_closed,
                  size: 50,
                  color: Colors.blue,
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: 80.w,
                child: Row(children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 0,
                      color: TextColor_shadowcolor(),
                    ),
                  ),
                  Text(
                    'Social Login',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 30,
                        color: draw.color_textstatus,
                        letterSpacing: 2),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 0,
                      color: TextColor_shadowcolor(),
                    ),
                  ),
                ]),
              )),
          Flexible(
              flex: 3,
              child: SizedBox(
                width: 80.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton(
                            width: 80.w,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: TextColor_shadowcolor()),
                            ),
                            elevation: 0,
                            btnColor: BGColor_shadowcolor(),
                            buttonType: ButtonType.google,
                            buttonSize: ButtonSize
                                .medium, // small(default), medium, large
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
                        const SizedBox(
                          height: 20,
                        ),
                        SignInButton(
                            width: 80.w,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: TextColor_shadowcolor()),
                            ),
                            elevation: 0,
                            btnColor: BGColor_shadowcolor(),
                            buttonType: ButtonType.apple,
                            buttonSize: ButtonSize
                                .medium, // small(default), medium, large
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
                      ],
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
                ),
              )),
        ],
      ),
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
