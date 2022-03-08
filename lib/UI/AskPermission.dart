import 'package:clickbyme/Dialogs/checkPermissions.dart';
import 'package:clickbyme/UI/UserCheck.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class AskPermissionPage extends StatefulWidget {
  const AskPermissionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AskPermissionPageState();
}

class _AskPermissionPageState extends State<AskPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Container(
        child: PermissionCheck(context),
      ),
    );
  }
}
// 바디 만들기
Widget PermissionCheck(BuildContext context) {
  final List<String> list_title = <String>[
    '파일',
  ];
  final List<String> list_content = <String>[
    '포스팅을 진행하기 위하여 갤러리 및 내외장 파일에 접근 허용이 필요합니다.',
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 4,
      ),
      Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'HabitMind에서 사용하는 권한',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
            ],
          )
      ),
      SizedBox(height: 20,),
      SizedBox(
        child: Card(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list_title[0],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600, // bold
                    ),
                  ),
                  const Divider(
                    height: 10,
                    thickness: 0.5,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.black,
                  ),
                  Text(
                    list_content[0],
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600, // bold
                    ),
                  ),
                ],
              )
          )
        ),
      ),
      SizedBox(height: 10,),
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '위 필수 권한을 허용해야 앱을 실행할 수 있습니다.\n'
                  '선택 권한은 기능 사용 시 노출되며, 허용없이도 앱 이용이 가능합니다.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
          ],
        )
      ),
      SizedBox(height: 50,),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            requestPermission(context);
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0
          ),
          child: const Text(
            "허용하기",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600, // bold
            ),
          ),
        ),
      )
    ],
  );
}

Future requestPermission(context) async {
  checkPermissions(context);
}
