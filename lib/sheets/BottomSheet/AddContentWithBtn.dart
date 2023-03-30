// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Tool/NoBehavior.dart';

AddContentWithBtn(context, title, content, btn, searchnode) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: Get.width > 1000 ? Get.width * 0.7 : Get.width,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: Get.width > 1000 ? Get.width * 0.7 : Get.width,
              ),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return GestureDetector(
                        onTap: (() {
                          searchnode.unfocus();
                        }),
                        child: infos(context, title, content, btn),
                      );
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

infos(context, title, content, btn) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 10,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              title == const SizedBox()
                  ? const SizedBox(
                      height: 0,
                    )
                  : const SizedBox(
                      height: 20,
                    ),
              title,
              const SizedBox(
                height: 20,
              ),
              content,
              const SizedBox(
                height: 30,
              ),
              btn,
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}
