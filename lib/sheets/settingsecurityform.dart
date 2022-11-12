import 'package:clickbyme/Auth/SecureAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Tool/TextSize.dart';

settingsecurityform(
  BuildContext context,
  String id,
  bool doc,
  String doc_pin_number,
  int doc_what_secure,
  bool can_auth,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
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
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: GestureDetector(
                onTap: () {},
                child: SheetSecurity(context, id, doc, doc_pin_number,
                    doc_what_secure, can_auth),
              ),
            ));
      }).whenComplete(() {});
}

SheetSecurity(
  BuildContext context,
  String id,
  doc,
  String doc_pin_number,
  int doc_what_secure,
  bool can_auth,
) {
  return SizedBox(
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              content(
                  context, id, doc, doc_pin_number, doc_what_secure, can_auth)
            ],
          )));
}

content(
  BuildContext context,
  String id,
  doc,
  String doc_pin_number,
  int doc_what_secure,
  bool can_auth,
) {
  String username = Hive.box('user_info').get(
    'id',
  );
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetPlatform.isMobile == true
            ? (GetPlatform.isAndroid == true
                ? ((doc_what_secure == 0 || doc_what_secure == 999) && can_auth
                    ? ListTile(
                        dense: true,
                        minLeadingWidth: 30,
                        horizontalTitleGap: 10,
                        leading: Icon(
                          Icons.fingerprint,
                          color: Colors.blue.shade400,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(
                              () => SecureAuth(
                                  string: '지문',
                                  id: id,
                                  doc_secret_bool: doc,
                                  doc_pin_number: doc_pin_number,
                                  unlock: false),
                              transition: Transition.downToUp);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey.shade400),
                        title: Text(doc == true ? '지문인식 잠금해제' : '지문인식 잠금설정',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                      )
                    : SizedBox())
                : (doc_what_secure == 0
                    ? ListTile(
                        dense: true,
                        minLeadingWidth: 30,
                        horizontalTitleGap: 10,
                        leading: Icon(
                          Icons.face,
                          color: Colors.blue.shade400,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(
                              () => SecureAuth(
                                    string: '얼굴',
                                    id: id,
                                    doc_secret_bool: doc,
                                    doc_pin_number: doc_pin_number,
                                    unlock: false,
                                  ),
                              transition: Transition.downToUp);
                        },
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey.shade400),
                        title: Text(doc == true ? '얼굴인식 잠금해제' : '얼굴인식 잠금설정',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                      )
                    : SizedBox()))
            : (SizedBox()),
        (doc_what_secure == 1 || doc_what_secure == 999
            ? ListTile(
                dense: true,
                minLeadingWidth: 30,
                horizontalTitleGap: 10,
                leading: Icon(
                  Icons.pin,
                  color: Colors.blue.shade400,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                      () => SecureAuth(
                          string: '핀',
                          id: id,
                          doc_secret_bool: doc,
                          doc_pin_number: doc_pin_number,
                          unlock: false),
                      transition: Transition.downToUp);
                },
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.grey.shade400),
                title: Text(doc == true ? '핀번호 잠금해제' : '핀번호 잠금설정',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
              )
            : SizedBox()),
        const SizedBox(
          height: 20,
        ),
      ],
    ));
  });
}
