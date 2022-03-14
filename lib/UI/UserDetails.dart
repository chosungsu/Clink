import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Tool/checkId.dart';
import 'AfterSignUp.dart';
import 'BeforeSignUp.dart';

UserDetails(BuildContext context) {
  String name = "", email = "", cnt = "";
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
        child: const Text(
          '내 정보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ),
      FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return showBeforeSignUp(context);
          } else {
            name = snapshot.data.toString().split("/")[1];
            email = snapshot.data.toString().split("/")[3];
            cnt = snapshot.data.toString().split("/")[5];
            return showAfterSignUp(name, email, cnt, context);
          }
        },
        future: checkId(context),
      )
    ],
  );
}
