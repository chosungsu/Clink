import 'package:clickbyme/DB/TODO.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

ListViewWidget(BuildContext context, String string) {
  List<String> widgetList = ['건강 플래너', '대중교통', '일정 정리', 'MY 알리미'];
  List<String> iconList = [
    'assets/images/icon-link.png',
    'assets/images/icon-chat.png',
    'assets/images/date.png',
    'assets/images/food.png'
  ];

  return Column(
    children: [
      SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: NeumorphicText(
                  string,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 3,
                    color: Colors.black54,
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: GridView.builder(
                  itemCount: widgetList.length, //item 개수
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //item 의 반목문 항목 형성
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Image.asset(
                              iconList[index].toString(),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Text(
                            widgetList[index].toString(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          )),
      const Padding(
        padding: EdgeInsets.only(bottom: 15),
      )
    ],
  );
}
