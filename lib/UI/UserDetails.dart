import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';

import 'Sign/AfterSignUp.dart';
import 'Sign/BeforeSignUp.dart';

UserDetails(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 10,
      ),
      Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            border: NeumorphicBorder.none(),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
            depth: -10,
            color: Color.fromARGB(255, 252, 249, 249),
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
