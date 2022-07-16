import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';

import 'SignProfileHome.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: ContainerDesign(
            color: Colors.blue.shade400,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                Icons.person,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Hive.box('user_info').get('id') == null
                          ? const SizedBox(
                              height: 45,
                              child: Center(
                                child: Text(
                                  '현재 로그인이 되어있지 않습니다.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 45,
                              child: Center(
                                child: Text(
                                  Hive.box('user_info').get('id').toString() +
                                      '님 Profile Card',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Container(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.blue.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                                onPressed: () => {},
                                icon: Icon(
                                  Icons.motion_photos_on,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  '포토북',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),),
                      ),
                      SizedBox(
                        height: 40,
                        child: Container(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.blue.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                                onPressed: () => {},
                                icon: Icon(
                                  Icons.card_giftcard,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  '포인트',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )),
                      ),
                      SizedBox(
                        height: 40,
                        child: Container(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.blue.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                                onPressed: () => {},
                                icon: Icon(
                                  Icons.badge,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  '뱃지',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )),
                      ),
                    ],
                  ),
                )
              ],
            )));
    /*SignProfileHome(
                  Hive.box('user_info').get('id'),
                  Hive.box('user_info').get('email'),
                  Hive.box('user_info').get('count').toString(),
                  context,
                  height));*/
  }
}
