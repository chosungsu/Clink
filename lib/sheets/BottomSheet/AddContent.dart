// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Tool/NoBehavior.dart';

AddContent(context, title, content, searchnode) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: Get.height > 600 ? Get.height * 0.5 : 300,
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : (Get.width > 1500 ? Get.width / 3 : Get.width / 2),
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
                        onTap: () {
                          searchnode.unfocus();
                        },
                        child: infos(context, title, content),
                      );
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

infos(context, title, content) {
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
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width > 1500
                                  ? (Get.width / 3 - 40) * 0.2
                                  : (Get.width / 2 - 40) * 0.2),
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
                height: 20,
              ),
            ],
          )));
}
