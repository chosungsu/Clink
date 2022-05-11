import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

destroyBackKey(BuildContext context) {
  Hive.box('user_setting').get('login_delete') == 1 ||
          Hive.box('user_setting').get('login_delete') == null
      ? showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('종료'),
            content: const Text('앱을 종료하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('아니요'),
              ),
              TextButton(
                onPressed: () {
                  Hive.box('user_info').get('autologin') == false
                      ? Hive.box('user_info').delete('id')
                      : null;
                  SystemNavigator.pop();
                },
                child: const Text('네'),
              ),
            ],
          ),
        )
      : Navigator.pop(context);
}
