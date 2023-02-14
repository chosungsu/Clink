// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names
import 'package:clickbyme/Tool/AndroidIOS.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/FRONTENDPART/Route/initScreenLoading.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'BACKENDPART/Locale/Locale.dart';
import 'Enums/PushNotification.dart';
import 'Enums/Variables.dart';
import 'FRONTENDPART/Route/subuiroute.dart';
import 'LocalNotiPlatform/NotificationApi.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

void main() async {
  ///flutter를 시작하게 하는 main function입니다.
  ///웹과 앱에서의 환경설정을 다르게 구성해야 하므로 아래처럼 작성되었습니다.

  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        name: 'linki',
        options: FirebaseOptions(
            apiKey: 'AIzaSyDmkVyvA80pDPV59DNd27yhqLkEgcHHFJU',
            appId: '1:789398252263:web:75abc4946fa7fe798e5042',
            messagingSenderId: '789398252263',
            projectId: 'habit-tracker-8dad1'));
  } else {
    CodeByPlatform({
      MobileAds.instance.initialize(),
      await Firebase.initializeApp(
          name: 'linki',
          options: FirebaseOptions(
              apiKey: 'AIzaSyDmkVyvA80pDPV59DNd27yhqLkEgcHHFJU',
              appId: '1:789398252263:android:21d69620fcd7caaa8e5042',
              messagingSenderId: '789398252263',
              projectId: 'habit-tracker-8dad1'))
    }, null, null);
  }

  await Hive.initFlutter();
  await Hive.openBox('user_info');
  await Hive.openBox('user_setting');
  NotificationApi.init(initScheduled: true);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  ///MyApp Class
  ///
  ///환경에 따라 GetMaterialApp, GetCupertinoApp을 구분한다.
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: ((p0, p1, p2) {
      return ReturnByPlatform(
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: Locale('ko', 'KR'),
            home: const SplashPage(),
          ),
          GetCupertinoApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: Locale('ko', 'KR'),
            home: const SplashPage(),
          ),
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: Locale('ko', 'KR'),
            home: const SplashPage(),
          ));
    }));
  }
}

class SplashPage extends StatefulWidget {
  ///SplashPage Class
  ///
  ///initScreen으로 앱 최초 실행시 필요한 세팅을 해주고 UI 띄운다.
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
    double height = MediaQuery.of(context).size.height;
    StatusBarControl.setColor(draw.backgroundcolor, animated: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BGColor(),
        body: SafeArea(
            child: SizedBox(
                height: height,
                child: LayoutBuilder(
                  builder: ((context, constraint) {
                    return ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Responsivelayout(SameView(constraint.maxHeight),
                                SameView(constraint.maxHeight))
                          ],
                        )
                      ],
                    );
                  }),
                ))));
  }

  ///SameView
  ///
  ///Landscape와 Portrait뷰가 동일한 경우의 위젯입니다.
  ///name이 공백일 경우 버튼, 공백이 아닌 경우 로딩을 띄운다.
  Widget SameView(double maxHeight) {
    return SizedBox(
      height: maxHeight <= 100 ? 300 : maxHeight,
      child: maxHeight <= 300
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50.w,
                  child: Center(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.crop,
                        size: 30,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      NeumorphicText(
                        'LOBBY',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.lightBlue,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  )),
                ),
                SizedBox(
                    width: 40.w,
                    child: name == ''
                        ? SizedBox(
                            width: 30.w,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                GoToMain();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Get Start',
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontSize: contentTextsize())),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SpinKitThreeBounce(
                            size: 30,
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade200,
                                    shape: BoxShape.circle),
                              );
                            },
                          )),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60.h,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.crop,
                        size: 30,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      NeumorphicText(
                        'LOBBY',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.lightBlue,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  )),
                ),
                Spacer(),
                SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    name == ''
                        ? SizedBox(
                            width: 50.w,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                GoToMain();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Get Start',
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontSize: contentTextsize())),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SpinKitThreeBounce(
                            size: 30,
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade200,
                                    shape: BoxShape.circle),
                              );
                            },
                          )
                  ],
                )),
                SizedBox(
                  height: 30,
                )
              ],
            ),
    );
  }
}

///checkForInitialMessage
///
///알람을 받은 현황이 있는지 체크합니다.
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
