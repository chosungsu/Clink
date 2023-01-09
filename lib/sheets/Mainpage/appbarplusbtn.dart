// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../Tool/TextSize.dart';

Widgets_plusbtn() {
  Widget title;
  Widget content;
  title = const SizedBox();
  content = Column(
    children: [
      ListTile(
        onTap: () async {
          //Pinchannelgetsecond(0, '빈페이지');
          Get.back();
        },
        trailing: const Icon(
          Ionicons.newspaper_outline,
          color: Colors.blue,
        ),
        title: Text(
          '페이퍼뷰 생성',
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize()),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ListTile(
        onTap: () {
          Get.back();
        },
        trailing: const Icon(
          FontAwesome.photo,
          color: Colors.blue,
        ),
        title: Text(
          '포토공간 생성',
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize()),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ListTile(
        onTap: () async {
          Get.back();
        },
        trailing: const Icon(
          Feather.box,
          color: Colors.blue,
        ),
        title: Text(
          '즐겨찾기 생성',
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize()),
          overflow: TextOverflow.ellipsis,
        ),
      )
    ],
  );
  return [title, content];
}
