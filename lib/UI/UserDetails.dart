import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'AfterSignUp.dart';
import 'BeforeSignUp.dart';

UserDetails(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 15,
      ),
      Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            border: NeumorphicBorder.none(),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
            depth: 5,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                child: NeumorphicText(
                  '내 정보',
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 3,
                    color: Colors.black54,
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Hive.box('user_info').get('id') != null
                  ? showAfterSignUp(
                      Hive.box('user_info').get('id'),
                      Hive.box('user_info').get('email'),
                      Hive.box('user_info').get('count').toString(),
                      context)
                  : showBeforeSignUp(context)
            ],
          )),
    ],
  );
}
