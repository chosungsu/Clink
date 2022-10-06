import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
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
            child: GestureDetector(
                onTap: () {
                  searchNode_forth_section.unfocus();
                },
                child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      children: [
                        readycontent(context, textEditingController4,
                            searchNode_forth_section),
                      ],
                    ))),
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
  int changeset = 0;
  textEditingController4.text = cal.repeatdate.toString();
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
                                      title: Text('주간 반복'),
                                      onChanged: (value) =>
                                          setState(() => changeset = value!),
                                    ),
                                  ),
                                  SizedBox(
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
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              '주간 반복',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  SizedBox(
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
                                          title: Text('월간 반복'),
                                          onChanged: (value) => setState(
                                              () => changeset = value!),
                                        ),
                                      ),
                                      SizedBox(
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
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '월간 반복',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(
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
                                          title: Text('연간 반복'),
                                          onChanged: (value) => setState(
                                              () => changeset = value!),
                                        ),
                                      ),
                                      SizedBox(
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
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '연간 반복',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(
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
                      onPressed: () {
                        Get.back();
                        cal.setrepeatdate(
                            int.parse(textEditingController4.text),
                            changeset == 0
                                ? '주'
                                : (changeset == 1 ? '월' : '연'));
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
            )
        /*Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        focusNode: searchNode_forth_section,
                        textAlign: TextAlign.center,
                        controller: textEditingController4,
                        style: TextStyle(
                            color: Colors.black, fontSize: contentTextsize()),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue.shade400)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '주간 반복',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        Get.back();
                        cal.setrepeatdate(
                            int.parse(textEditingController4.text));
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
            )*/
        );
  });
}
