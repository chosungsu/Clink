import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../Tool/TextSize.dart';

userinfo_draggable(BuildContext context) {
  return Get.bottomSheet(
          Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: StatefulBuilder(builder: ((context, setState) {
                return GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    snap: true,
                    initialChildSize: 0.75,
                    minChildSize: 0.5,
                    maxChildSize: 0.95,
                    builder: (_, controller) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                                height: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    40) *
                                                0.2,
                                        alignment: Alignment.topCenter,
                                        color: Colors.black45),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: controller,
                                child: SheetPageUserInfo(context),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '모두 확인하였습니다.',
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
                        ),
                      );
                    },
                  ),
                );
              }))),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          isDismissible: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {});
}

SheetPageUserInfo(BuildContext context) {
  final List<String> list_title = <String>[
    '개인정보 수집 및 이용 동의',
    '수집항목',
    '수집 및 이용 목적',
    '보유 및 이용 기간',
  ];
  final List<String> list_content = <String>[
    '회사(이하, 담당자)는 앱 서비스와 관련하여 아래의 목적으로 개인정보를 수집 및 이용하며, 회원의 개인정보를 안전하게 취급하는 데 최선을 다합니다.',
    '담당자는 서비스 이용을 위해 필요한 최소한의 개인정보만을 수집합니다.\n' +
        '1) 로그인 및 회원가입 시점에서 이용자로부터 수집하는 개인정보는 아래와 같습니다.\n' +
        '카카오 계정(이메일, 이용자 이름) 또는 구글 계정(이메일, 이용자 이름), 자동 로그인 설정 여부(선택)',
    '담당자는 이용자의 개인정보를 다음과 같은 목적으로만 이용합니다.\n' +
        '1) 회원가입 및 권리\n' +
        '이용자 식별, 이용자 정보 관리, 고지사항 알림 등\n' +
        '2) 이벤트 정보 안내\n' +
        '각종 이벤트 및 정보 제공, 신규 및 맞춤성 서비스 제공\n' +
        '3) 민원 처리\n' +
        '문의 시 민원인의 신원 및 민원사항 확인',
    '1) 담당자는 우너칙적으로 이용자의 개인정보를 회원 탈퇴 시 바로 파기합니다.\n' +
        '따라서 담당자는 회원탈퇴 시 경고문으로 고지하지만 이를 인지한 이후 회원탈퇴 시 이용자는 개인정보 파기로 인해 개인기록복원이 일부 불가할 수 있음을 알려드립니다.',
  ];
  return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list_title.length,
      itemBuilder: ((context, index) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ListTile(
              horizontalTitleGap: 10,
              dense: true,
              title: Text(list_title[index].toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        index == 0 ? contentTitleTextsize() : contentTextsize(),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              horizontalTitleGap: 10,
              dense: true,
              title: Text(list_content[index].toString(),
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: contentTextsize(),
                  )),
            ),
          ],
        );
      }));
}
