// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../FRONTENDPART/Page/QRPage.dart';
import '../../Tool/TextSize.dart';

Widgets_plusbtn(context) {
  Widget title;
  Widget content;
  title = const SizedBox();
  content = Column(
    children: [
      ListTile(
        onTap: () {
          Get.to(
              () => const QRPage(
                    type: 0,
                  ),
              transition: Transition.fade);
        },
        trailing: const Icon(
          Ionicons.create_outline,
          color: Colors.black,
        ),
        title: Text(
          '직접 생성',
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
          Get.to(
              () => const QRPage(
                    type: 1,
                  ),
              transition: Transition.fade);
        },
        trailing: const Icon(
          Ionicons.qr_code_outline,
          color: Colors.black,
        ),
        title: Text(
          '복사한 코드로 생성',
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
