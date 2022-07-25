import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/Tool/SheetGetx/calendarshowsetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../Tool/SheetGetx/calendarthemesetting.dart';


SheetPage(
  BuildContext context, int setcal_fromsheet,
    calendarshowsetting controll_cals, calendarthemesetting controll_cals2, int themecal_fromsheet
) {

  return SizedBox(
      height: 300,
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 70,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 70) * 0.4,
                      ),
                      Container(
                          width: (MediaQuery.of(context).size.width - 70) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 70) * 0.4,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(context, setcal_fromsheet, controll_cals, controll_cals2, themecal_fromsheet)
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

content(
  BuildContext context, int setcal_fromsheet,
    calendarshowsetting controll_cals, calendarthemesetting controll_cals2, int themecal_fromsheet
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 180,
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
                                primary: setcal_fromsheet ==
                                    0
                                    ? Colors.grey.shade400
                                    : Colors.white,
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black45,
                                )),
                            onPressed: () {
                              setState(() {
                                controll_cals.setcals1w();
                                setcal_fromsheet = controll_cals.showcalendar;
                              });
                            },
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: NeumorphicText(
                                      '1week',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: setcal_fromsheet ==
                                            0
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
                              primary: setcal_fromsheet ==
                                  1
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              controll_cals.setcals2w();
                              setcal_fromsheet = controll_cals.showcalendar;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '2weeks',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: setcal_fromsheet ==
                                          1
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
                              primary: setcal_fromsheet ==
                                  2
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              controll_cals.setcals1m();
                              setcal_fromsheet = controll_cals.showcalendar;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '1month',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: setcal_fromsheet ==
                                          2
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
              child: Text('일정테마 변경',
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
                                primary: themecal_fromsheet ==
                                        0
                                    ? Colors.grey.shade400
                                    : Colors.white,
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black45,
                                )),
                            onPressed: () {
                              setState(() {
                                controll_cals2.themecals1();
                                themecal_fromsheet = controll_cals2.themecalendar;
                              });
                            },
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: NeumorphicText(
                                      '달력테마',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: themecal_fromsheet ==
                                                0
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
                              primary: themecal_fromsheet ==
                                      1
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              controll_cals2.themecals2();
                              themecal_fromsheet = controll_cals2.themecalendar;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '시간표테마',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: themecal_fromsheet ==
                                              1
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
