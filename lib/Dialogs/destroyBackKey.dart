import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

destroyBackKey (BuildContext context){
  showDialog(
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
          onPressed: () => SystemNavigator.pop(),
          child: const Text('네'),
        ),
      ],
    ),
  );
}