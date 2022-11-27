import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../Tool/Getx/calendarsetting.dart';

SheetPage(BuildContext context, int theme, int view, String docid) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
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
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(context, theme, view, docid)
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
        children: [
          Text('설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

content(BuildContext context, int theme, int view, String docid) {
  final controll_cals = Get.put(calendarsetting());
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Text('달력 설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            primary: controll_cals.showcalendar == 0
                                ? Colors.grey.shade400
                                : Colors.white,
                            side: const BorderSide(
                              width: 1,
                              color: Colors.black45,
                            )),
                        onPressed: () {
                          setState(() {
                            controll_cals.setcals1w(docid);
                            view = controll_cals.showcalendar;
                          });
                        },
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '1주씩',
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: controll_cals.showcalendar == 0
                                        ? Colors.white
                                        : Colors.black45,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  )),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          primary: controll_cals.showcalendar == 1
                              ? Colors.grey.shade400
                              : Colors.white,
                          side: const BorderSide(
                            width: 1,
                            color: Colors.black45,
                          )),
                      onPressed: () {
                        setState(() {
                          controll_cals.setcals2w(docid);
                          view = controll_cals.showcalendar;
                        });
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '2주씩',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: controll_cals.showcalendar == 1
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          primary: controll_cals.showcalendar == 2
                              ? Colors.grey.shade400
                              : Colors.white,
                          side: const BorderSide(
                            width: 1,
                            color: Colors.black45,
                          )),
                      onPressed: () {
                        setState(() {
                          controll_cals.setcals1m(docid);
                          view = controll_cals.showcalendar;
                        });
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '1달씩',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: controll_cals.showcalendar == 2
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: Text('일정카드컬러',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            primary: controll_cals.themecalendar == 0
                                ? Colors.grey.shade400
                                : Colors.white,
                            side: const BorderSide(
                              width: 1,
                              color: Colors.black45,
                            )),
                        onPressed: () {
                          setState(() {
                            controll_cals.themecals1(docid);
                            theme = controll_cals.themecalendar;
                          });
                        },
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '기본원색',
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: controll_cals.themecalendar == 0
                                        ? Colors.white
                                        : Colors.black45,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  )),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          primary: controll_cals.themecalendar == 1
                              ? Colors.grey.shade400
                              : Colors.white,
                          side: const BorderSide(
                            width: 1,
                            color: Colors.black45,
                          )),
                      onPressed: () {
                        setState(() {
                          controll_cals.themecals2(docid);
                          theme = controll_cals.themecalendar;
                        });
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '파스텔',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: controll_cals.themecalendar == 1
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  });
}
