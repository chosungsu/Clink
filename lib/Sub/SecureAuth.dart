import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';

class SecureAuth extends StatefulWidget {
  const SecureAuth({
    Key? key,
    required this.string,
    required this.id,
    required this.doc_secret_bool,
    required this.doc_pin_number,
  }) : super(key: key);
  final String string;
  final String id;
  final String doc_pin_number;
  final bool doc_secret_bool;
  @override
  State<StatefulWidget> createState() => _SecureAuthState();
}

class _SecureAuthState extends State<SecureAuth> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  LocalAuthentication auth = LocalAuthentication();
  bool can_auth = false;
  List<BiometricType> availablebio = [];
  String signauth = '인증이 불가합니다!';
  bool canAuthenticate = false;
  List<String> currentPin = ["", "", "", ""];
  int pinindex = 0;
  TextEditingController pinoneController = TextEditingController();
  TextEditingController pintwoController = TextEditingController();
  TextEditingController pinthirdController = TextEditingController();
  TextEditingController pinfourController = TextEditingController();
  String strpin = '';

  Future<void> _checkBiometrics() async {
    bool check = false;
    try {
      check = await auth.canCheckBiometrics;
      canAuthenticate = check || await auth.isDeviceSupported();
    } on PlatformException catch (e) {}
    if (!mounted) return;
    setState(() {
      can_auth = canAuthenticate;
    });
  }

  Future<void> _getavailableBioList() async {
    List<BiometricType> avails = [];
    try {
      avails = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {}
    setState(() {
      availablebio = avails;
    });
  }

  Future<void> _authenticate() async {
    bool _auth = false;
    try {
      _auth = await auth.authenticate(
          localizedReason:
              widget.string == '지문' ? '지문인식이 필요합니다!' : '얼굴인식이 필요합니다!',
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            stickyAuth: true,
          ),
          authMessages: <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: widget.string == '지문' ? '지문인식' : '얼굴인식',
              cancelButton: '취소',
            ),
            const IOSAuthMessages(
              cancelButton: '취소',
            ),
          ]);
    } on PlatformException catch (e) {}
    setState(() {
      signauth = _auth ? '인증에 성공하였습니다!' : '인증에 실패하였습니다!';
      if (_auth) {
        widget.doc_secret_bool == true
            ? firestore.collection('MemoDataBase').doc(widget.id).update({
                'security': false,
                'pinnumber': '0000',
              }).whenComplete(() {
                Flushbar(
                  backgroundColor: Colors.blue.shade400,
                  titleText: Text('Notice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTitleTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  messageText: Text('정상적으로 잠금이 해제되었습니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  icon: const Icon(
                    Icons.info_outline,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  duration: const Duration(seconds: 2),
                  leftBarIndicatorColor: Colors.blue.shade100,
                ).show(context).whenComplete(() {
                  Get.back();
                });
              })
            : firestore.collection('MemoDataBase').doc(widget.id).update({
                'security': true,
                'pinnumber': '0000',
              }).whenComplete(() {
                Flushbar(
                  backgroundColor: Colors.blue.shade400,
                  titleText: Text('Notice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTitleTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  messageText: Text('정상적으로 잠금이 설정되었습니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  icon: const Icon(
                    Icons.info_outline,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  duration: const Duration(seconds: 2),
                  leftBarIndicatorColor: Colors.blue.shade100,
                ).show(context).whenComplete(() {
                  Get.back();
                });
              });
      }
    });
  }

  Future<void> pinauthenticate() async {
    if (pinindex < 4) {
      //거절
      Flushbar(
        backgroundColor: Colors.red.shade400,
        titleText: Text('Notice',
            style: TextStyle(
              color: Colors.white,
              fontSize: contentTitleTextsize(),
              fontWeight: FontWeight.bold,
            )),
        messageText: Text('핀번호 4자리가 필요합니다!',
            style: TextStyle(
              color: Colors.white,
              fontSize: contentTextsize(),
              fontWeight: FontWeight.bold,
            )),
        icon: const Icon(
          Icons.info_outline,
          size: 25.0,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.red.shade100,
      ).show(context).whenComplete(() {});
    } else {
      //승인
      if (widget.doc_pin_number == strpin || widget.doc_pin_number == '0000') {
        widget.doc_secret_bool == true
            ? firestore.collection('MemoDataBase').doc(widget.id).update({
                'security': false,
                'pinnumber': '0000',
              }).whenComplete(() {
                Flushbar(
                  backgroundColor: Colors.blue.shade400,
                  titleText: Text('Notice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTitleTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  messageText: Text('정상적으로 잠금이 해제되었습니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  icon: const Icon(
                    Icons.info_outline,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  duration: const Duration(seconds: 2),
                  leftBarIndicatorColor: Colors.blue.shade100,
                ).show(context).whenComplete(() {
                  Get.back();
                });
              })
            : firestore.collection('MemoDataBase').doc(widget.id).update({
                'security': true,
                'pinnumber': strpin,
              }).whenComplete(() {
                Flushbar(
                  backgroundColor: Colors.blue.shade400,
                  titleText: Text('Notice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTitleTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  messageText: Text('정상적으로 잠금이 설정되었습니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentTextsize(),
                        fontWeight: FontWeight.bold,
                      )),
                  icon: const Icon(
                    Icons.info_outline,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  duration: const Duration(seconds: 2),
                  leftBarIndicatorColor: Colors.blue.shade100,
                ).show(context).whenComplete(() {
                  Get.back();
                });
              });
      } else {
        Flushbar(
          backgroundColor: Colors.red.shade400,
          titleText: Text('Notice',
              style: TextStyle(
                color: Colors.white,
                fontSize: contentTitleTextsize(),
                fontWeight: FontWeight.bold,
              )),
          messageText: Text('핀번호가 일치하지 않습니다!',
              style: TextStyle(
                color: Colors.white,
                fontSize: contentTextsize(),
                fontWeight: FontWeight.bold,
              )),
          icon: const Icon(
            Icons.info_outline,
            size: 25.0,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 2),
          leftBarIndicatorColor: Colors.red.shade100,
        ).show(context).whenComplete(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _getavailableBioList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pinoneController.dispose();
    pintwoController.dispose();
    pinthirdController.dispose();
    pinfourController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.keyboard_arrow_left,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        60 -
                                        160,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text('',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 23,
                                                    //color: widget.coloritems,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ],
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height - 80,
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BuildContent(),
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  BuildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 100,
          child: NeumorphicIcon(
            widget.string == '지문'
                ? Icons.fingerprint
                : (widget.string == '얼굴' ? Icons.face : Icons.pin),
            size: 100,
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                depth: 2,
                surfaceIntensity: 0.5,
                color: Colors.blue.shade400,
                lightSource: LightSource.topLeft),
          ),
        ),
        widget.string == '지문'
            ? Text(
                '아래 인증하기 버튼을 눌러\n인증을 완료해주세요',
                style: GoogleFonts.lobster(
                  fontSize: contentTextsize(),
                  color: TextColor_shadowcolor(),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            : (widget.string == '얼굴'
                ? Text('아래 인증하기 버튼을 눌러\n인증을 완료해주세요',
                    style: GoogleFonts.lobster(
                      fontSize: contentTextsize(),
                      color: TextColor_shadowcolor(),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center)
                : const SizedBox()),
        widget.string != '핀'
            ? const SizedBox(
                height: 80,
              )
            : const SizedBox(
                height: 30,
              ),
        widget.string == '핀'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PinNum(
                    textEditingController: pinoneController,
                  ),
                  PinNum(
                    textEditingController: pintwoController,
                  ),
                  PinNum(
                    textEditingController: pinthirdController,
                  ),
                  PinNum(
                    textEditingController: pinfourController,
                  )
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        const SizedBox(
          height: 30,
        ),
        widget.string == '핀'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Keyboard(
                          num: 1,
                          onPressed: () {
                            pinIndexSet('1');
                          }),
                      Keyboard(
                          num: 2,
                          onPressed: () {
                            pinIndexSet('2');
                          }),
                      Keyboard(
                          num: 3,
                          onPressed: () {
                            pinIndexSet('3');
                          })
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Keyboard(
                          num: 4,
                          onPressed: () {
                            pinIndexSet('4');
                          }),
                      Keyboard(
                          num: 5,
                          onPressed: () {
                            pinIndexSet('5');
                          }),
                      Keyboard(
                          num: 6,
                          onPressed: () {
                            pinIndexSet('6');
                          })
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Keyboard(
                          num: 7,
                          onPressed: () {
                            pinIndexSet('7');
                          }),
                      Keyboard(
                          num: 8,
                          onPressed: () {
                            pinIndexSet('8');
                          }),
                      Keyboard(
                          num: 9,
                          onPressed: () {
                            pinIndexSet('9');
                          })
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: const SizedBox()),
                      Keyboard(
                          num: 0,
                          onPressed: () {
                            pinIndexSet('0');
                          }),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(Icons.backspace, color: TextColor()),
                            onPressed: () {
                              clearPin();
                            },
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.blue,
              ),
              onPressed: widget.string != '핀' ? _authenticate : pinauthenticate,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '인증하기',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  pinIndexSet(String text) {
    if (pinindex == 0) {
      pinindex = 1;
    } else {
      pinindex++;
    }
    setPin(pinindex, text);
    currentPin[pinindex - 1] = text;
    String tmp = '';
    for (var element in currentPin) {
      tmp += element;
    }
    if (tmp.length == 4) {
      strpin = tmp.substring(tmp.length - 4, tmp.length);
    }
    print(strpin);
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinoneController.text = text;
        break;
      case 2:
        pintwoController.text = text;
        break;
      case 3:
        pinthirdController.text = text;
        break;
      case 4:
        pinfourController.text = text;
        break;
    }
  }

  clearPin() {
    if (pinindex == 0) {
      pinindex = 0;
    } else if (pinindex == 4) {
      setPin(pinindex, "");
      currentPin[pinindex - 1] = "";
      pinindex--;
    } else {
      setPin(pinindex, "");
      currentPin[pinindex - 1] = "";
      pinindex--;
    }
  }
}

class Keyboard extends StatelessWidget {
  final int num;
  final Function() onPressed;
  Keyboard({required this.num, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: TextColor().withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(1, 1)),
              BoxShadow(
                  color: BGColor().withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(-1, -1)),
            ],
            color: BGColor_shadowcolor()),
        alignment: Alignment.center,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            '$num',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize(),
                color: TextColor()),
            textAlign: TextAlign.center,
          ),
        ));
  }
}

class PinNum extends StatelessWidget {
  final TextEditingController textEditingController;
  PinNum({required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return ContainerDesign(
      child: Container(
        width: 50,
        child: TextField(
          controller: textEditingController,
          enabled: false,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(15),
          ),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize(),
              color: TextColor()),
        ),
      ),
      color: BGColor_shadowcolor(),
    );
  }
}
