import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyTheme {
  MyTheme._();
  static Color kPrimaryColor = const Color(0xff7C7B9B);
  static Color kPrimaryColorVariant = const Color(0xff686795);
  static Color kAccentColor = const Color(0xffFCAAAB);
  static Color kAccentColorVariant = const Color(0xffF7A3A2);
  static Color kUnreadChatBG = const Color(0xffEE1D1D);
  static Color chatbotColor = Colors.lightGreen;
  static Color userchatColor = Colors.white;
  static Color colorWhite = Colors.white;
  static Color colorblack = Colors.black;
  static Color colorWhitestatus = Colors.white60;
  static Color colorblackstatus = Colors.black45;
  static Color colorWhite_drawer = Colors.white;
  static Color colorblack_drawer = Colors.black;
  static Color colorselected_drawer = Colors.deepPurple;
  static Color colornotselected_drawer = Colors.black45;
  static Color colorselected_black_drawer = Colors.deepPurple;
  static Color colornotselected_black_drawer = Colors.white;
  static Color colororigred = Colors.red;
  static Color colororigorange = Colors.orange;
  static Color colororigblue = Colors.blue;
  static Color colororiggreen = Colors.green;
  static Color colorpastelred = Colors.red.shade200;
  static Color colorpastelorange = Colors.orange.shade200;
  static Color colorpastelblue = Colors.blue.shade200;
  static Color colorpastelgreen = Colors.green.shade200;

  static const TextStyle heading2 = TextStyle(
    color: Color(0xff686795),
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static const TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle bodyText1 = TextStyle(
      color: Color(0xffAEABC9),
      fontSize: 14,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w500);

  static const TextStyle bodyTextMessage =
      TextStyle(
        fontSize: 13, 
        letterSpacing: 1.5, 
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis);

  static const TextStyle bodyTextTime = TextStyle(
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}