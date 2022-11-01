import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/calendarsetting.dart';
import '../Tool/RadioCustom.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

showrepeatdate(
  BuildContext context,
  TextEditingController textEditingController4,
  FocusNode searchNode_forth_section,
) {
  Get.bottomSheet(
    Container(
      margin: const EdgeInsets.all(10),
      child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    readycontent(context, textEditingController4,
                        searchNode_forth_section),
                  ],
                )),
          )),
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  ).whenComplete(() {});
}

readycontent(
  BuildContext context,
  TextEditingController textEditingController4,
  FocusNode searchNode_forth_section,
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
                  context, textEditingController4, searchNode_forth_section),
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
      child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: Colors.black,
                  letterSpacing: 2),
              text: '일정을 ',
            ),
            TextSpan(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: Colors.blue.shade400,
                  letterSpacing: 2),
              text: '주/월/년단위',
            ),
            TextSpan(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: Colors.black,
                  letterSpacing: 2),
              text: '로 자동으로 채워드립니다.',
            ),
          ],
        ),
      ),
    ],
  ));
}

content(
  BuildContext context,
  TextEditingController textEditingController4,
  FocusNode searchNode_forth_section,
) {
  var cal = Get.put(calendarsetting());
  int changeset = cal.repeatwhile == '주'
      ? 0
      : (cal.repeatwhile == '월' ? 1 : (cal.repeatwhile == 'no' ? 0 : 2));
  textEditingController4.text = cal.repeatdate.toString();
  List<bool> switchval = List.filled(3, false, growable: true);
  if (cal.repeatwhile == '주') {
    switchval[0] = true;
  } else if (cal.repeatwhile == '월') {
    switchval[1] = true;
  } else if (cal.repeatwhile == '년') {
    switchval[2] = true;
  } else {}
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return GetBuilder<calendarsetting>(
        builder: (_) => Column(
              children: [
                ListView.builder(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: ((context, index) {
                      return index == 0
                          ? GestureDetector(
                              onTap: () {
                                /*setState(() {
                          if (choicelist[0] == 1) {
                            choicelist.clear();
                            choicelist.add(0);
                            choicelist.add(0);
                          } else {
                            choicelist.clear();
                            choicelist.add(1);
                            choicelist.add(0);
                          }
                        });*/
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        changeset = 0;
                                      });
                                    },
                                    child: MyRadioListTile<int>(
                                      value: 0,
                                      groupValue: changeset,
                                      leading: 'W',
                                      trailing: changeset == 0
                                          ? Transform.scale(
                                              scale: 1,
                                              child: Switch(
                                                  activeColor: Colors.blue,
                                                  inactiveThumbColor:
                                                      Colors.black,
                                                  inactiveTrackColor:
                                                      Colors.grey.shade100,
                                                  value: switchval[0],
                                                  onChanged: (bool val) {
                                                    setState(() {
                                                      changeset = 0;
                                                      switchval[0] = val;
                                                      if (switchval[1] ==
                                                              true ||
                                                          switchval[2] ==
                                                              true) {
                                                        switchval[1] = false;
                                                        switchval[2] = false;
                                                      }
                                                    });
                                                  }),
                                            )
                                          : const SizedBox(),
                                      title: const Flexible(
                                        fit: FlexFit.tight,
                                        child: Text('주간 반복'),
                                      ),
                                      onChanged: (value) => setState(() {
                                        changeset = value!;
                                        switchval[0] = false;
                                      }),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  changeset == 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                focusNode:
                                                    searchNode_forth_section,
                                                textAlign: TextAlign.center,
                                                controller:
                                                    textEditingController4,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        contentTextsize()),
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400)),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.blue
                                                                  .shade400)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              '번 반복',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          : (index == 1
                              ? GestureDetector(
                                  onTap: () {
                                    /*setState(() {
                          if (choicelist[1] == 1) {
                            choicelist.clear();
                            choicelist.add(0);
                            choicelist.add(0);
                          } else {
                            choicelist.clear();
                            choicelist.add(0);
                            choicelist.add(1);
                          }
                        });*/
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            changeset = 1;
                                          });
                                        },
                                        child: MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: changeset,
                                          leading: 'M',
                                          trailing: changeset == 1
                                              ? Transform.scale(
                                                  scale: 1,
                                                  child: Switch(
                                                      activeColor: Colors.blue,
                                                      inactiveThumbColor:
                                                          Colors.black,
                                                      inactiveTrackColor:
                                                          Colors.grey.shade100,
                                                      value: switchval[1],
                                                      onChanged: (bool val) {
                                                        setState(() {
                                                          changeset = 1;
                                                          switchval[1] = val;
                                                          if (switchval[0] ==
                                                                  true ||
                                                              switchval[2] ==
                                                                  true) {
                                                            switchval[0] =
                                                                false;
                                                            switchval[2] =
                                                                false;
                                                          }
                                                        });
                                                      }),
                                                )
                                              : const SizedBox(),
                                          title: const Flexible(
                                            fit: FlexFit.tight,
                                            child: Text('월간 반복'),
                                          ),
                                          onChanged: (value) => setState(() {
                                            changeset = value!;
                                            switchval[1] = false;
                                          }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      changeset == 1
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    focusNode:
                                                        searchNode_forth_section,
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        textEditingController4,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            contentTextsize()),
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400)),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade400)),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '번 반복',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    /*setState(() {
                          if (choicelist[1] == 1) {
                            choicelist.clear();
                            choicelist.add(0);
                            choicelist.add(0);
                          } else {
                            choicelist.clear();
                            choicelist.add(0);
                            choicelist.add(1);
                          }
                        });*/
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            changeset = 2;
                                          });
                                        },
                                        child: MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: changeset,
                                          leading: 'Y',
                                          trailing: changeset == 2
                                              ? Transform.scale(
                                                  scale: 1,
                                                  child: Switch(
                                                      activeColor: Colors.blue,
                                                      inactiveThumbColor:
                                                          Colors.black,
                                                      inactiveTrackColor:
                                                          Colors.grey.shade100,
                                                      value: switchval[2],
                                                      onChanged: (bool val) {
                                                        setState(() {
                                                          changeset = 2;
                                                          switchval[2] = val;
                                                          if (switchval[1] ==
                                                                  true ||
                                                              switchval[0] ==
                                                                  true) {
                                                            switchval[1] =
                                                                false;
                                                            switchval[0] =
                                                                false;
                                                          }
                                                        });
                                                      }),
                                                )
                                              : const SizedBox(),
                                          title: const Flexible(
                                            fit: FlexFit.tight,
                                            child: Text('연간 반복'),
                                          ),
                                          onChanged: (value) => setState(() {
                                            changeset = value!;
                                            switchval[2] = false;
                                          }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      changeset == 2
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    focusNode:
                                                        searchNode_forth_section,
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        textEditingController4,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            contentTextsize()),
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400)),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade400)),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '번 반복',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ));
                    })),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        primary: Colors.blue,
                      ),
                      onPressed: () async {
                        if (switchval[0] != false ||
                            switchval[1] != false ||
                            switchval[2] != false) {
                          if (textEditingController4.text.isEmpty ||
                              int.parse(textEditingController4.text) == 0) {
                            cal.repeatwhile = 'no';
                            Get.back();
                          } else {
                            cal.setrepeatdate(
                                int.parse(textEditingController4.text),
                                changeset == 0
                                    ? '주'
                                    : (changeset == 1 ? '월' : '년'));
                            final reloadpage = await Get.dialog(
                                    OSDialogthird(context, '알림', Builder(
                                  builder: (context) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: SingleChildScrollView(
                                        child: Text(
                                            '설정하신 ' +
                                                cal.repeatdate.toString() +
                                                '기간은 일정의 첫 시작일을 반복기간에 포함한 기간인가요? (\'네 맞습니다\'를 누르시면 자동으로 설정하신 기간에서 1일을 감소하여 저장해드립니다!)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: Colors.blueGrey)),
                                      ),
                                    );
                                  },
                                ), pressed2)) ??
                                false;
                            if (reloadpage) {
                              Get.back();
                              if (switchval[0] != false ||
                                  switchval[1] != false ||
                                  switchval[2] != false) {
                                if (textEditingController4.text.isEmpty) {
                                  cal.repeatwhile = 'no';
                                } else {
                                  cal.setrepeatdate(
                                      int.parse(textEditingController4.text) -
                                          1,
                                      changeset == 0
                                          ? '주'
                                          : (changeset == 1 ? '월' : '년'));
                                }
                              } else {
                                cal.setrepeatdate(0, 'no');
                              }
                            } else {
                              Get.back();
                              if (switchval[0] != false ||
                                  switchval[1] != false ||
                                  switchval[2] != false) {
                                if (textEditingController4.text.isEmpty) {
                                  cal.repeatwhile = 'no';
                                } else {
                                  cal.setrepeatdate(
                                      int.parse(textEditingController4.text),
                                      changeset == 0
                                          ? '주'
                                          : (changeset == 1 ? '월' : '년'));
                                }
                              } else {
                                cal.setrepeatdate(0, 'no');
                              }
                            }
                          }
                        } else {
                          cal.setrepeatdate(0, 'no');
                          Get.back();
                        }
                      },
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '설정하기',
                                style: const NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: Colors.white,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ));
  });
}
