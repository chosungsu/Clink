import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickbyme/DB/PushNotification.dart';
import 'package:clickbyme/Provider/EventProvider.dart';
import 'package:clickbyme/Sub/DayEventAdd.dart';
import 'package:clickbyme/Sub/DayLog.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'Auth/GoogleSignInController.dart';
import 'Auth/KakaoSignInController.dart';
import 'Page/LoginSignPage.dart';
import 'Page/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoContext.clientId = 'b5e60a90f0204c0bb09625df79a11772';
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('user_info');
  await Hive.openBox('user_setting');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInController(),
          child: LoginSignPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => KakaoSignInController(),
          child: LoginSignPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleSignInController(),
          child: ProfilePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => KakaoSignInController(),
          child: ProfilePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => EventProvider(),
          child: DayEventAdd(),
        ),
        ChangeNotifierProvider(
          create: (context) => EventProvider(),
          child: DayLog(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 255, 255, 255),
          canvasColor: Colors.transparent,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
              .copyWith(secondary: const Color(0xFF012980)),
        ),
        home: SplashPage(),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  bool islogined = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notifications = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });
    checkForInitialMessage();
    /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);*/
    /*scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            if (Hive.box('user_info').get('id') != null ||
                Hive.box('user_info').get('autologin') == true) {
              GoToMain(context);
            } else {
              GoToLogin(context);
            }

            Timer(
              const Duration(milliseconds: 1000),
              () {
                scaleController.stop();
              },
            );
          }
        },
      );

    scaleAnimation =
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);

    Timer(Duration(seconds: 2), () {
      setState(() {
        scaleController.forward();
      });
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //scaleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - 
        MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            height: height,
            child: Column(
              children: [
                SizedBox(
                    height: height * 0.55,
                    child: Center(
                      child: NeumorphicText(
                        'StormDot',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.blueGrey,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    )
                    /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NeumorphicText(
                    'StormDot',
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: Colors.blueGrey,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                    DefaultTextStyle(
                      style: const TextStyle(fontSize: 20.0),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText('나의 개인화 마인드트랙',
                              speed: Duration(milliseconds: 150)),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        //displayFullTextOnTap: false,
                      ),
                    ),
                  ],
                )*/
                    ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: height * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Hive.box('user_info').get('id') == null ||
                                Hive.box('user_info').get('autologin') == false
                            ? Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.grey.shade400,
                                      ),
                                      onPressed: () {
                                        GoToLogin(context);
                                      },
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: NeumorphicText(
                                                '로그인',
                                                style: const NeumorphicStyle(
                                                  shape: NeumorphicShape.flat,
                                                  depth: 3,
                                                  color: Colors.white,
                                                ),
                                                textStyle: NeumorphicTextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              )
                            : const Text(
                                '어서오세요',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2 // bold
                                    ),
                              ),
                        Hive.box('user_info').get('id') == null ||
                                Hive.box('user_info').get('autologin') == false 
                                ? const SizedBox.shrink()
                                : GoToMain(context),
                      ],
                    )
                    /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SpinKitFadingCircle(
                      color: Colors.white,
                    ),
                    Hive.box('user_info').get('id') == null ||
                            Hive.box('user_info').get('autologin') == false
                        ? const Text(
                            '로그인 페이지 이동 중...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2 // bold
                                ),
                          )
                        : const Text(
                            '어서오세요',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2 // bold
                                ),
                          )
                  ],
                )*/
                    ),
              ],
            )));
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notifications = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
    }
  }
}
