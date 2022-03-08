import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../UI/UserCheck.dart';

checkPermissions(BuildContext context) async {
  PermissionStatus status = await Permission
      .storage.request();
  if (!status.isGranted) {
    //허용이 안된 경우
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "알림",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            content: const Text(
              "[설정] > [권한 설정]을 확인해주세요",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            actions: [
              TextButton(
                child: Text("설정하기"),
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                  if (!status.isGranted) {
                    //허용이 안된 경우
                    GoToPermission(context);
                  } else {
                    GoToLogin(context);
                  }
                },
              ),
            ],
          );
        }
    );
  } else {
    //허용이 된 경우
    GoToLogin(context);
  }
}