import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/settingpageonly.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import '../../Route/subuiroute.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({
    Key? key,
    required this.height,
    required this.controller,
    required this.node,
  }) : super(key: key);
  final double height;
  final TextEditingController controller;
  final FocusNode node;
  @override
  Widget build(BuildContext context) {
    String name = Hive.box('user_info').get('id');
    final peopleadd = Get.put(PeopleAdd());
    return Container(
        alignment: Alignment.center,
        child: Hive.box('user_info').get('id') == null
            ? GestureDetector(
                onTap: () {
                  GoToLogin(context, 'isnotfirst');
                },
                child: GetBuilder<PeopleAdd>(
                  builder: (_) => ContainerDesign(
                      color: Colors.blue.shade400,
                      child: Column(
                        children: [
                          ListTile(
                            subtitle: const Text(
                              '이 카드를 클릭하셔서 로그인하세요!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              overflow: TextOverflow.fade,
                            ),
                            title: Text(
                              '현재 로그인이 되어있지 않습니다.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      )),
                ),
              )
            : GestureDetector(
                onTap: () {
                  setUsers(context, node, controller, name);
                },
                child: GetBuilder<PeopleAdd>(
                  builder: (_) => ContainerDesign(
                      color: Colors.blue.shade400,
                      child: Column(
                        children: [
                          ListTile(
                            subtitle: const Text(
                              'MY 정보 변경하시려면 카드 클릭하세요!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              overflow: TextOverflow.fade,
                            ),
                            title: Text(
                              peopleadd.secondname + '님 Profile Card',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      )),
                ),
              ));
  }
}
