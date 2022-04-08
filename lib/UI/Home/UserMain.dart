import 'package:clickbyme/DB/TODO.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

UserMain(BuildContext context) {
  String name = Hive.box('user_info').get('id');
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeumorphicText(
                    '\'' + name + '님,',
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: Colors.blueGrey,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Row(
                    children: [
                      NeumorphicText(
                        '당신만의 ',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.black54,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      NeumorphicText(
                        '인생 조각을',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.orange.shade400,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      NeumorphicText(
                        ' 만들어보세요\'',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.black54,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 15),
      )
    ],
  );
}
