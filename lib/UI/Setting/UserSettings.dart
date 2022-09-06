import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Setting/ShowLicense.dart';
import 'package:clickbyme/sheets/DeleteUser.dart';
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
                      ? showreadycontent(context, height)
                      : (index == 1
                          ? Get.to(() => OptionChangePage(),
                              transition: Transition.rightToLeft)
                          : (index == 2
                              ? addgroupmember(context, searchNode, controller)
                              : Get.to(() => ShowLicense(),
                                  transition: Transition.rightToLeft)));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ContainerDesign(
                        color: BGColor(),
                        child: SizedBox(
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
}
