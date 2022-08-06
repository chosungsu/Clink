import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickbyme/DB/PushNotification.dart';
import 'package:clickbyme/LocalNotiPlatform/localnotification.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:provider/provider.dart';
import 'Auth/GoogleSignInController.dart';
import 'Auth/KakaoSignInController.dart';
import 'Page/LoginSignPage.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'b5e60a90f0204c0bb09625df79a11772');
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
        /*ChangeNotifierProvider(
          create: (context) => GoogleSignInController(),
          child: const ProfilePage(colorbackground: null, coloritems: null,),
        ),
        ChangeNotifierProvider(
          create: (context) => KakaoSignInController(),
          child: const ProfilePage(colorbackground: null, coloritems: null,),
        ),*/
      ],
      child: GetMaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: MyTheme.kPrimaryColor,
          canvasColor: Colors.transparent,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
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

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  bool islogined = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notifications = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });
    checkForInitialMessage();
    checkForInitialMessagefromlocal();
    /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);*/
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Hive.box('user_info').get('id') == null ||
                    Hive.box('user_info').get('autologin') == false
                ? null
                : GoToMain(context);
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
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scaleController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: body());
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

  checkForInitialMessagefromlocal() async {
    localnotification.initLocalNotificationPlugin();
  }

  body() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SizedBox(
        height: height,
        child: Column(
          children: [
            SizedBox(
                height: height * 0.55,
                child: Center(
                  child: NeumorphicText(
                    'Habit Tracker',
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
                )),
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
                        : DefaultTextStyle(
                            style: const TextStyle(fontSize: 15.0),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText('로그인중입니다...',
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                    speed: const Duration(milliseconds: 150)),
                              ],
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              //displayFullTextOnTap: false,
                            ),
                          ),
                  ],
                )),
          ],
        ));
  }
}
