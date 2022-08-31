import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import '../Tool/TextSize.dart';

destroyBackKey(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text('종료',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize())),
      content: Text('앱을 종료하시겠습니까?',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize())),
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
  );
}
