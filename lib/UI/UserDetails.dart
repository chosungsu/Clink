import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'AfterSignUp.dart';
import 'BeforeSignUp.dart';

UserDetails(BuildContext context) {
  
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
      Hive.box('user_info').get('id') != null
          ? showAfterSignUp(
            Hive.box('user_info').get('id'), 
            Hive.box('user_info').get('email'), 
            Hive.box('user_info').get('count').toString(), 
            context)
          : showBeforeSignUp(context)
    ],
  );
}