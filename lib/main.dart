import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickbyme/DB/PushNotification.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:clickbyme/initScreenLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'LocalNotiPlatform/NotificationApi.dart';
import 'package:flutter/foundation.dart';
import 'Tool/BGColor.dart';
import 'Tool/Getx/PeopleAdd.dart';
import 'Tool/Getx/notishow.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-5775667984133884~4010656648',
        'android': 'ca-app-pub-5775667984133884~4968515094',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
        //'ios': 'ca-app-pub-5775667984133884/9014699179',
        //'android': 'ca-app-pub-5775667984133884/1962792390'
      };
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '	caac43875f322f45a8cec21c52741a24');
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('user_info');
  await Hive.openBox('user_setting');
  NotificationApi.init(initScheduled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
    );
  }
}

class SplashPage extends StatefulWidget {
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
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);*/
  }

  @override
  void dispose() {
    super.dispose();
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

/*
  Future<Widget?> initScreen() async {
    if (name == '') {
    } else {
      await firestore.collection('User').doc(name).get().then((value) {
        if (value.exists) {
          peopleadd.secondnameset(value.data()!['subname']);
        }
      });
      await firestore
          .collection('HomeViewCategories')
          .doc(Hive.box('user_setting').get('usercode'))
          .get()
          .then((value) {
        peopleadd.defaulthomeviewlist.clear();
        peopleadd.userviewlist.clear();
        if (value.exists) {
          for (int i = 0; i < value.data()!['viewcategory'].length; i++) {
            peopleadd.defaulthomeviewlist.add(value.data()!['viewcategory'][i]);
          }
          for (int j = 0; j < value.data()!['hidecategory'].length; j++) {
            peopleadd.userviewlist.add(value.data()!['hidecategory'][j]);
          }
          firestore
              .collection('HomeViewCategories')
              .doc(Hive.box('user_setting').get('usercode'))
              .set({
            'usercode': Hive.box('user_setting').get('usercode'),
            'viewcategory': peopleadd.defaulthomeviewlist,
            'hidecategory': peopleadd.userviewlist
          }, SetOptions(merge: true));
          defaulthomeviewlist = peopleadd.defaulthomeviewlist;
          userviewlist = peopleadd.userviewlist;
        } else {
          peopleadd.defaulthomeviewlist.add(defaulthomeviewlist);
          peopleadd.userviewlist.add(userviewlist);
          firestore
              .collection('HomeViewCategories')
              .doc(Hive.box('user_setting').get('usercode'))
              .set({
            'usercode': Hive.box('user_setting').get('usercode'),
            'viewcategory': peopleadd.defaulthomeviewlist,
            'hidecategory': peopleadd.userviewlist
          }, SetOptions(merge: true));
          defaulthomeviewlist = peopleadd.defaulthomeviewlist;
          userviewlist = peopleadd.userviewlist;
        }
      });
      await firestore.collection('AppNoticeByUsers').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['username'] == name ||
              element.data()['sharename'].toString().contains(name)) {
            updateid.add(element.data()['read']);
          }
        }
        if (updateid.contains('no')) {
          isread = false;
          notilist.isread = false;
        } else {
          isread = true;
          notilist.isread = true;
        }
      });
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: waitingbody()
        //body()
        );
  }

  waitingbody() {
    print('start');
    return SizedBox(
        child: name == ''
            ? body()
            : FutureBuilder(
                future: initScreen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingbody();
                  } else {
                    return Hive.box('user_info').get('id') == '' ||
                            Hive.box('user_info').get('autologin') == false
                        ? body()
                        : loadingbody();
                  }
                },
              ));
  }

  loadingbody() {
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
                    DefaultTextStyle(
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
                        totalRepeatCount: 2,
                        onFinished: () {
                          GoToMain(context);
                        },
                        //displayFullTextOnTap: false,
                      ),
                    ),
                  ],
                )),
          ],
        ));
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          GoToLogin(context, 'first');
                        },
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                )),
          ],
        ));
  }
}
