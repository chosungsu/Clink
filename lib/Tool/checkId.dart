import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

checkId(BuildContext context) async {
  String? userInfo = "", userInfo2 = "";
  const storage = FlutterSecureStorage();
  userInfo = await storage.read(
      key: "google_login"
  );
  userInfo2 = await storage.read(
      key: "kakao_login"
  );
  if (userInfo != null && userInfo2 == null) {
    return userInfo;
  } else if (userInfo2 != null && userInfo == null) {
    return userInfo2;
  } else {
    return userInfo;
  }
}