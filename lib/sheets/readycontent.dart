import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

showreadycontent(
  BuildContext context,
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
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
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
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: readycontent(
                  context,
                ),
              )),
        );
      }).whenComplete(() {});
}

readycontent(
  BuildContext context,
) {
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
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(
                context,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('도움&문의',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content(
  BuildContext context,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/instagram.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('광고 및 개발문의',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                Text('DM : @dev_habittracker_official',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 15)),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
            String body = await _getEmailBody();
            final Email email = Email(
              body: body,
              subject: '[오류 및 건의사항]',
              recipients: ['ski06043@gmail.com'],
              cc: [],
              bcc: [],
              attachmentPaths: [],
              isHTML: false,
            );

            await FlutterEmailSender.send(email);
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Icon(
                        Icons.forward_to_inbox,
                        size: 30,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('오류 및 건의사항',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          Text('개발자에게 이메일보내기',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15)),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        )
      ],
    );
  });
}

Future<String> _getEmailBody() async {
  Map<String, dynamic> userInfo = _getUserInfo();
  Map<String, dynamic> appInfo = await _getAppInfo();
  Map<String, dynamic> deviceInfo = await _getDeviceInfo();

  String body = "";

  body += "==============\n";
  body += "아래는 문의하시는 사용자 정보로, 참고용입니다.\n\n";

  userInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  appInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  deviceInfo.forEach((key, value) {
    body += "$key: $value\n\n";
  });

  body += "==============\n\n";
  body += "아래에 오류 및 건의사항을 적어주시면 됩니다.문의하신 내용은 업데이트에 최대한 반영해보도록 하겠습니다.감사합니다!\n\n";
  body += "==============\n\n";
  return body;
}

Map<String, dynamic> _getUserInfo() {
  String name = Hive.box('user_info').get('id');
  String email = Hive.box('user_info').get('email');
  return {"사용자 이름": name, "사용자 이메일": email};
}

Future<Map<String, dynamic>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (GetPlatform.isAndroid == true) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (GetPlatform.isIOS == true) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS 버전": "Android $release (SDK $sdkInt)",
    "기기": "$manufacturer $model"
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {"OS 버전": "$systemName $version", "기기": "$machine"};
}

Future<Map<String, dynamic>> _getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return {"앱 버전": info.version};
}
