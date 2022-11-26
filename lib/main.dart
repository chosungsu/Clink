// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:clickbyme/DB/PushNotification.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/FRONTENDPART/Route/initScreenLoading.dart';
import 'package:clickbyme/Tool/ResponsiveUI.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'BACKENDPART/Locale/Locale.dart';
import 'Enums/Variables.dart';
import 'FRONTENDPART/Route/subuiroute.dart';
import 'LocalNotiPlatform/NotificationApi.dart';
import 'Tool/Getx/PeopleAdd.dart';
import 'Tool/Getx/notishow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('user_info');
  await Hive.openBox('user_setting');
  NotificationApi.init(initScheduled: true);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: ((p0, p1, p2) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en', 'US'),
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
  String name = Hive.box('user_info').get('id') ?? '';

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
        body: OrientationBuilder(builder: ((context, orientation) {
          return waitingbody(orientation);
        })));
  }

  Widget waitingbody(Orientation orientation) {
    return SizedBox(
        child: name == '' ? body(orientation) : loadingbody(orientation));
  }

  Widget loadingbody(Orientation orientation) {
    return SizedBox(
        child: ResponsiveMainUI(
            Row(
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
            ),
            Column(
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
                        width: 80.w,
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
            ),
            orientation));
  }

  Widget body(Orientation orientation) {
    return SizedBox(
        child: ResponsiveMainUI(
            Column(
              children: [
                Flexible(
                    flex: 2,
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
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          child: OutlineGradientButton(
                            child: SizedBox(
                                width: 40.w,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Get Start',
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
            ),
            Column(
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
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                      Text('Get Start',
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
            ),
            orientation));
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
