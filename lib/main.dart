// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickbyme/DB/PushNotification.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Route/initScreenLoading.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/mongoDB/mongodatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'Enums/Variables.dart';
import 'Route/subuiroute.dart';
import 'LocalNotiPlatform/NotificationApi.dart';
import 'Tool/Getx/PeopleAdd.dart';
import 'Tool/Getx/notishow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '	caac43875f322f45a8cec21c52741a24');
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('user_info');
  await Hive.openBox('user_setting');
  NotificationApi.init(initScheduled: true);
  await MongoDB.connect();
  runApp(
    const MyApp(),
  );
  /*runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );*/
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: ((p0, p1, p2) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        //useInheritedMediaQuery: true,
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        home: const SplashPage(),
      );
    }));
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> //with TickerProviderStateMixin
{
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  bool islogined = false;
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  List updateid = [];
  bool isread = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id') ?? '';
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];

  @override
  void initState() {
    super.initState();
    checkForInitialMessage();
    initScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StatusBarControl.setColor(draw.backgroundcolor, animated: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BGColor(),
        body: waitingbody());
  }

  Widget waitingbody() {
    return SizedBox(child: name == '' ? body() : loadingbody());
  }

  Widget loadingbody() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SizedBox(
        height: height,
        child: Column(
          children: [
            Flexible(
                flex: 3,
                child: Center(
                  child: NeumorphicText(
                    'LinkAI',
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
                flex: 1,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: height * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SpinKitThreeBounce(
                          size: 25,
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade200,
                                  shape: BoxShape.circle),
                            );
                          },
                        ),
                      ],
                    )))
          ],
        ));
  }

  Widget body() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SizedBox(
        height: height,
        child: Column(
          children: [
            Flexible(
                flex: 3,
                child: Center(
                  child: NeumorphicText(
                    'LinkAI',
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
                flex: 1,
                child: SizedBox(
                    height: height * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          child: OutlineGradientButton(
                            child: SizedBox(
                                width: 60.w,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: contentTextsize())),
                                    ],
                                  ),
                                )),
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.blueGrey],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            strokeWidth: 2,
                            backgroundColor: Colors.blue.shade300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            radius: const Radius.circular(10),
                            onTap: () {
                              GoToLogin('first');
                            },
                          ),
                        )
                      ],
                    ))),
          ],
        ));
  }
}

void checkForInitialMessage() async {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    PushNotification notifications = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
  });
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    PushNotification notifications = PushNotification(
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
    );
  }
}
