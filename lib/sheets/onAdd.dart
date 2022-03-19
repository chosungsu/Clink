import 'package:clickbyme/Sub/YourTags.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Sub/WritePost.dart';

onAdd(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add_link_rounded),
                title: const Text('피드 태그 추가'),
                onTap: () => {
                  //개인태그 페이지로 이동
                  Navigator.pop(context),
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_rounded),
                title: const Text('사람 태그 추가'),
                onTap: () => {
                  Navigator.pop(context),
                },
              ),
            ],
          ),
        );
      });
}
