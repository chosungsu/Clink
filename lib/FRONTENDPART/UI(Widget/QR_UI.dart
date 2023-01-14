// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../Tool/AndroidIOS.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Tool/BGColor.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/uisetting.dart';
import '../Route/mainroute.dart';

QR_UI(
    maxWidth,
    maxHeight,
    List<TextEditingController> texteditingcontrollerlist,
    List<FocusNode> focusnodelist,
    int type,
    String id) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());

  return SizedBox(
    height: maxHeight,
    width: maxWidth,
    child: PRView(maxWidth, maxHeight, texteditingcontrollerlist, focusnodelist,
        type, id),
  );
}

PRView(
    maxWidth,
    maxHeight,
    List<TextEditingController> texteditingcontrollerlist,
    List<FocusNode> focusnodelist,
    int type,
    String id) {
  final searchNode = FocusNode();
  final draw = Get.put(navibool());
  List tabname = ['New', 'History'];
  List current = type == 0 ? [true, false] : [false, true];
  List titletype0 = ['제목', '타입지정'];
  List titletype1 = ['QR 클립보드'];
  List<String> dropdownList = ['리스트뷰', '그리드뷰', '캘린더뷰'];
  String selectedDropdown = Hive.box('user_setting').get('addtype') ?? '리스트뷰';
  String textchange1 = '';

  return StatefulBuilder(builder: ((context, setState) {
    return SizedBox(
        height: maxHeight,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (index == 0) {
                              current[0] == true ? null : current[0] = true;
                              current[1] = false;
                            } else {
                              current[1] == true ? null : current[1] = true;
                              current[0] = false;
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 10,
                          ),
                          child: Text(
                            tabname[index],
                            style: TextStyle(
                                fontSize: contentTextsize(),
                                color: current.indexOf(true) == index
                                    ? Colors.purple.shade300
                                    : draw.color_textstatus),
                          ),
                        ),
                      );
                    })),
              ),
              current[0] == true
                  ? Type0UI(maxWidth, maxHeight, focusnodelist,
                      texteditingcontrollerlist, id)
                  : Type1UI(maxHeight, id),
            ],
          ),
        ));
  }));
}

Type0UI(maxWidth, maxHeight, List<FocusNode> focusnodelist,
    List<TextEditingController> texteditingcontrollerlist, String id) {
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());
  List titletype0 = ['제목', '코드번호', '뷰타입지정'];
  List<String> dropdownList = ['리스트뷰', '그리드뷰', '캘린더뷰'];
  String selectedDropdown = Hive.box('user_setting').get('addtype') ?? '리스트뷰';
  String textchange1 = '';
  int indexcnt = linkspaceset.indexcnt.length;

  return StatefulBuilder(builder: ((context, setState) {
    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: titletype0.length,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Text(
                      titletype0[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: maxWidth - 50,
                    child: ContainerDesign(
                        child: index == 0
                            ? SizedBox(
                                height: 30,
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 1,
                                  focusNode: focusnodelist[index],
                                  style: TextStyle(
                                      fontSize: contentTextsize(),
                                      color: TextColor()),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    hintText: '이곳에 입력...',
                                    hintStyle: TextStyle(
                                        fontSize: contentTextsize(),
                                        color: Colors.grey.shade400),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      textchange1 = text;
                                    });
                                  },
                                  controller: texteditingcontrollerlist[index],
                                ),
                              )
                            : (index == 1
                                ? SizedBox(
                                    height: 30,
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 1,
                                      readOnly: true,
                                      focusNode: focusnodelist[index],
                                      style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: TextColor()),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 10),
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        hintText: '고유코드번호가 이곳에 표시됩니다.',
                                        hintStyle: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: Colors.grey.shade400),
                                      ),
                                      controller:
                                          texteditingcontrollerlist[index]
                                            ..text = id +
                                                '@' +
                                                texteditingcontrollerlist[0]
                                                    .text,
                                    ),
                                  )
                                : SizedBox(
                                    height: 30,
                                    child: DropdownButton(
                                      value: selectedDropdown,
                                      items: dropdownList.map((String item) {
                                        return DropdownMenuItem<String>(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(item)),
                                          value: item,
                                        );
                                      }).toList(),
                                      style: TextStyle(
                                          color: draw.color_textstatus,
                                          fontSize: 20.0),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      isExpanded: true,
                                      icon: Icon(
                                        Feather.box,
                                        color: draw.color_textstatus,
                                      ),
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          selectedDropdown = value;
                                          Hive.box('user_setting')
                                              .put('addtype', value);
                                        });
                                      },
                                    ),
                                  )),
                        color: BGColor()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            })),
        Container(
          height: 30,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: ButtonColor(),
            ),
            onPressed: () async {
              if (texteditingcontrollerlist[0].text == '') {
                Snack.snackbars(
                    context: context,
                    title: '제목이 비어있어요!',
                    backgroundcolor: Colors.red,
                    bordercolor: draw.backgroundcolor);
              } else {
                await firestore.collection('PageView').add({
                  'id': id,
                  'spacename': texteditingcontrollerlist[0].text,
                  'pagename': uiset.pagelist[uiset.mypagelistindex].title,
                  'type': 0,
                  'index': indexcnt + 1,
                  'codename': texteditingcontrollerlist[1].text,
                  'canshow': '나 혼자만',
                }).whenComplete(() {
                  Snack.snackbars(
                      context: context,
                      title: '정상적으로 처리되었어요',
                      backgroundcolor: Colors.green,
                      bordercolor: draw.backgroundcolor);
                  linkspaceset.setcompleted(false);
                  linkspaceset.setspacelink(texteditingcontrollerlist[0].text);
                  Get.to(
                      () => const mainroute(
                            index: 0,
                          ),
                      transition: Transition.fadeIn);
                });
              }
            },
            child: SizedBox(
              height: 50,
              width: 80.w,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '생성',
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
              ),
            )),
        Container(
          height: 20,
        ),
      ],
    );
  }));
}

Type1UI(maxHeight, String id) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
          height: maxHeight - 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                AntDesign.frowno,
                color: Colors.orange,
                size: 30,
              ),
              Container(
                height: 20,
              ),
              Text(
                '생성하셨던 뷰의 히스토리는 비어있습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: contentTextsize(), color: draw.color_textstatus),
              ),
            ],
          ))
    ],
  );
}
