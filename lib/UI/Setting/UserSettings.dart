import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Setting/DeleteUser.dart';
import 'package:clickbyme/UI/Setting/OptionChangePage.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:clickbyme/sheets/addgroupmember.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Tool/ContainerDesign.dart';
import '../../sheets/readycontent.dart';

class UserSettings extends StatelessWidget {
  UserSettings(
      {Key? key,
      required this.height,
      required this.controller,
      required this.pcontroll})
      : super(key: key);
  final double height;
  final searchNode = FocusNode();
  final List<String> list_title = <String>[
    '도움 & 문의',
    '설정값 변경',
    '친구 초대하기',
    '라이선스',
  ];
  final PageController pcontroll;
  var name = Hive.box('user_info').get('id');
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: list_title.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  index == 0
                      ? showreadycontent(context, height, pcontroll)
                      : (index == 1
                          ? Get.to(() => OptionChangePage(),
                              transition: Transition.rightToLeft)
                          : (index == 2
                              ? addgroupmember(context, searchNode, controller)
                              : Get.to(() => OptionChangePage(),
                                  transition: Transition.rightToLeft)));
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ContainerDesign(
                        color: BGColor(),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(list_title[index],
                                    style: TextStyle(
                                        color: TextColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize())),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                child: NeumorphicIcon(
                                  Icons.navigate_next,
                                  size: 20,
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      color: TextColor(),
                                      lightSource: LightSource.topLeft),
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ));
          }),
    );
  }

  showreadycontent(
    BuildContext context,
    double height,
    PageController pController,
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
            margin: const EdgeInsets.all(10),
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  height: 280,
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
                  child: readycontent(context, height, pController),
                )),
          );
        }).whenComplete(() {});
  }
}
