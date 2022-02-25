import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clickbyme/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'Auth/GoogleSignInController.dart';
import 'Auth/KakaoSignInController.dart';
import 'Page/FeedPage.dart';
import 'Page/HomePage.dart';
import 'Page/ProfilePage.dart';
import 'Sub/LoginPage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
          child: LoginPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => KakaoSignInController(),
          child: LoginPage(),
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
        routes: <String, WidgetBuilder> {
          'home' : (context) => HomePage(),
          'feed' : (context) => FeedPage(),
          'profile' : (context) => ProfilePage(),
        },
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

  @override
  void initState() {
    super.initState();

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),)..addStatusListener(
          (status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const MyHomePage(title: 'SuChip'),
            ),
          );
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
      backgroundColor: const Color(0xff2efcff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'SuChip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            DefaultTextStyle(
                style: const TextStyle(fontSize: 20.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                        '내가 수집하는 취향트랙',
                        speed: Duration(milliseconds: 200)),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  //displayFullTextOnTap: false,
                ),
            ),
          ],
        )
      ),
    );
  }
}



