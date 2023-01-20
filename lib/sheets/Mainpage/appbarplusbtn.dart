// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../FRONTENDPART/Page/QRPage.dart';
import '../../Tool/TextSize.dart';

Widgets_plusbtn(
    context, checkid, textcontroller, searchnode, where, id, categorypicknum) {
  Widget title;
  Widget content;
  title = const SizedBox();
  content = Column(
    children: [
      ListTile(
        onTap: () {
          Get.back();
          func6(
              context, textcontroller, searchnode, where, id, categorypicknum);
        },
        trailing: const Icon(
          Ionicons.create_outline,
          color: Colors.black,
        ),
        title: Text(
          '페이지 생성',
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
          Get.to(() => QRPage(type: 0, id: checkid),
              transition: Transition.fade);
        },
        trailing: const Icon(
          Ionicons.qr_code_outline,
          color: Colors.black,
        ),
        title: Text(
          '박스 생성',
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize()),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
  return [title, content];
}
