import 'package:flutter/material.dart';

List<Map> drawerItems = [
  {
    'icon': Icons.home,
    'title': Text(
      '홈',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    )
  },
  {
    'icon': Icons.widgets,
    'title': Text(
      '피드',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    )
  },
  {
    'icon': Icons.account_circle,
    'title': Text(
      '계정',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    )
  }
];
