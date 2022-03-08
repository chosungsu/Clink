import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickbyme/UI/UserCheck.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'Auth/GoogleSignInController.dart';
import 'Auth/KakaoSignInController.dart';
import 'Page/FeedPage.dart';
import 'Page/HomePage.dart';
import 'Page/LoginSignPage.dart';
import 'Page/ProfilePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //화면회전 막기
  /*SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/
  KakaoContext.clientId = 'b5e60a90f0204c0bb09625df79a11772';
  await Firebase.initializeApp();
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
      ],
      child: MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xffdbf3ff),
          canvasColor: Colors.transparent,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: const Color(0xFF012980)),
        ),
        //home: SplashPage(),
        home: SplashPage(),
        /*routes: <String, WidgetBuilder> {
          '/home' : (context) => HomePage(),
          '/feed' : (context) => FeedPage(),
          '/profile' : (context) => ProfilePage(),
        },*/
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
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),)..addStatusListener(
          (status) {
        if (status == AnimationStatus.completed) {
          if (islogined) {
            GoToMain(context);
          } else {
            //퍼미션 요청부터 하자.
            GoToPermission(context);
            //GoToLogin(context);
          }

          Timer(
            const Duration(milliseconds: 1000),
                () {
              scaleController.reset();
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
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'HabitMind',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    DefaultTextStyle(
                      style: const TextStyle(fontSize: 20.0),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                              '내가 수집하는 개인화 마인드트랙',
                              speed: Duration(milliseconds: 150)),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        //displayFullTextOnTap: false,
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: (MediaQuery.of(context).size.height - 600),),
            SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SpinKitFadingCircle(
                      color: Colors.white,
                    ),
                    FutureBuilder(
                      builder: (context, snapshot) {
                        islogined = snapshot.hasData;
                        if (snapshot.hasData == false) {
                          return const Text(
                            '로그인 페이지 이동 중...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2// bold
                            ),
                          );
                        }
                        else {
                          return const Text(
                            '어서오세요',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2// bold
                            ),
                          );
                        }
                      },
                      future: issuccess(context),
                    ),
                  ],
                )
            ),
          ],
        )
      )
    );
  }
}



