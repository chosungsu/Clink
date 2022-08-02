import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/FormContentNet/ChatBotRoom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Tool/SheetGetx/onequeform.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/addcalendar.dart';

class FormCard extends StatelessWidget {
  FormCard(
      {Key? key, required this.height, required this.buy})
      : super(key: key);
  final double height;
  final bool buy;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  String username = Hive.box('user_info').get(
    'id',
  );
  static final cntdraw = Get.put(onequeform());
  DateTime Date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    cntdraw.setcnt();
    cntdraw.setresetcnt();
    return SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: Colors.blue.shade400,
            child: Column(
              children: [
                SizedBox(
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        cntdraw.cnt != 0
                            ? addcalendar(
                                context, searchNode, controller, username, Date, 'home')
                            : Flushbar(
                                backgroundColor: Colors.red.shade400,
                                titleText: Text('Notice',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: contentTitleTextsize(),
                                      fontWeight: FontWeight.bold,
                                    )),
                                messageText: Text(
                                    '오늘 할당량을 소진하셨습니다.\n버전 업그레이드 시 이용가능합니다!',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: contentTextsize(),
                                      fontWeight: FontWeight.bold,
                                    )),
                                icon: const Icon(
                                  Icons.info_outline,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                duration: const Duration(seconds: 3),
                                leftBarIndicatorColor: Colors.red.shade100,
                              ).show(context);
                      },
                      child: SizedBox(
                        height: 45,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue.shade500,
                                    child: const Icon(
                                      Icons.smart_toy,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            const Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                height: 45,
                                child: Center(
                                  child: Text(
                                    '원큐로 기록카드 만들기',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                            ),
                            cntdraw.cnt != 0
                                ? SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                            backgroundColor:
                                                Colors.blue.shade500,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cntdraw.cnt.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                  overflow: TextOverflow.fade,
                                                ),
                                                const Text(
                                                  '/5',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ],
                                            ))),
                                  )
                                : SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blue.shade500,
                                          child: const Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                          ],
                        ),
                      ),
                    ))
              ],
            )));
  }
}
