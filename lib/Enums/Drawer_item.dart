import 'package:flutter/material.dart';

List<Map> drawerItems = [
  {
    'icon': Icons.home,
    'title': Text(
      '메인홈',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    )
  },
  {
    'icon': Icons.explore,
    'title': Text(
      '탐색',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    )
  },
  {
    'icon': Icons.account_circle,
    'title': Text(
      '전체 설정',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    )
  }
];
