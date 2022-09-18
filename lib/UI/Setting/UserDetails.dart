import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/sheetmultiprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Auth/GoogleSignInController.dart';
import '../../Auth/KakaoSignInController.dart';
import '../Sign/UserCheck.dart';
import '../../sheets/DeleteUser.dart';

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
    return SizedBox(
        child: Hive.box('user_info').get('id') == null
            ? FocusedMenuHolder(
                menuItems: [
                    FocusedMenuItem(
                        trailingIcon: const Icon(
                          Icons.account_circle,
                          size: 30,
                        ),
                        backgroundColor: Colors.blue.shade200,
                        title: Text('로그인',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize())),
                        onPressed: () {
                          GoToLogin(context, 'isnotfirst');
                        })
                  ],
                duration: const Duration(seconds: 0),
                animateMenuItems: true,
                menuOffset: 20,
                bottomOffsetHeight: 10,
                menuWidth: MediaQuery.of(context).size.width - 40,
                openWithTap: true,
                onPressed: () {},
                child: ContainerDesign(
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
                    )))
            : FocusedMenuHolder(
                menuItems: [
                    FocusedMenuItem(
                        trailingIcon: const Icon(
                          Icons.badge,
                          size: 30,
                        ),
                        title: Text('닉네임 변경',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize())),
                        onPressed: () {
                          sheetmultiprofile(context, node, controller, name);
                        }),
                    FocusedMenuItem(
                        trailingIcon: const Icon(
                          Icons.manage_accounts,
                          size: 30,
                        ),
                        title: Text('다른 아이디 로그인',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize())),
                        onPressed: () {
                          Provider.of<GoogleSignInController>(context,
                                  listen: false)
                              .logout(context, Hive.box('user_info').get('id'));
                          GoToLogin(context, 'isnotfirst');
                        }),
                    FocusedMenuItem(
                        trailingIcon: const Icon(
                          Icons.account_circle,
                          size: 30,
                        ),
                        backgroundColor: Colors.red.shade200,
                        title: Text('회원탈퇴',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize())),
                        onPressed: () {
                          DeleteUserVerify(
                              context, Hive.box('user_info').get('id'));
                        })
                  ],
                duration: const Duration(seconds: 0),
                animateMenuItems: true,
                menuOffset: 20,
                bottomOffsetHeight: 10,
                menuWidth: MediaQuery.of(context).size.width - 40,
                openWithTap: true,
                onPressed: () {},
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
                )));
  }
}
