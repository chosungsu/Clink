// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../Tool/AndroidIOS.dart';
import 'package:qr_flutter/qr_flutter.dart';

QR_UI(maxWidth, maxHeight) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());

  return SizedBox(
    height: maxHeight,
    width: maxWidth,
    child: Responsivelayout(maxWidth, LSView(), PRView(maxHeight)),
  );
}

LSView() {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());
  return SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: ScrollConfiguration(
            behavior: NoBehavior(),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AntDesign.frowno,
                    color: Colors.orange,
                    size: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    '사용하셨던 QR 리스트는 비어있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: draw.color_textstatus),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: Get.width * 0.7,
          color: Colors.amber,
        ),
      ],
    ),
  );
}

PRView(maxHeight) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());
  List tabname = ['New', 'History'];
  List current = [true, false];

  return StatefulBuilder(builder: ((context, setState) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (index == 0) {
                          current[0] == true ? null : current[0] = true;
                          current[1] = false;
                        } else {
                          current[1] == true ? null : current[1] = true;
                          current[0] = false;
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 20 : 10,
                      ),
                      child: Text(
                        tabname[index],
                        style: TextStyle(
                            fontSize: contentTextsize(),
                            color: current.indexOf(true) == index
                                ? Colors.purple.shade300
                                : draw.color_textstatus),
                      ),
                    ),
                  );
                })),
          ),
          current[0] == true
              ? SizedBox(
                  height: maxHeight - 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImage(
                        data: "1234567890",
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: maxHeight - 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        AntDesign.frowno,
                        color: Colors.orange,
                        size: 30,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '사용하신 QR 히스토리가 없습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: contentTextsize(),
                            color: draw.color_textstatus),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }));
}
