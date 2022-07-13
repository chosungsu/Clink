import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';

import 'SignProfileHome.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 130,
          child: SignProfileHome(
                  Hive.box('user_info').get('id'),
                  Hive.box('user_info').get('email'),
                  Hive.box('user_info').get('count').toString(),
                  context,
                  height));
    /*Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: 
          Hive.box('user_info').get('id') != null
              ? SignProfileHome(
                  Hive.box('user_info').get('id'),
                  Hive.box('user_info').get('email'),
                  Hive.box('user_info').get('count').toString(),
                  context,
                  height)
              : SignProfileHome(
                  Hive.box('user_info').get('id'),
                  Hive.box('user_info').get('email'),
                  Hive.box('user_info').get('count').toString(),
                  context,
                  height))
              //showBeforeSignUp(context, height)),
    );*/
  }
}
