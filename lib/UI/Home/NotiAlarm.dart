import 'package:clickbyme/DB/Expandable.dart';
import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Tool/NoBehavior.dart';

class NotiAlarm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm> with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  int whatwantnotice = 0;
  String name = Hive.box('user_info').get('id');
  final List notinamelist = [
    '공지글',
    '푸쉬알림',
  ];
  final List<PageList> _list_ad = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Hive.box('user_setting').put('noti_home_click', 0);
    whatwantnotice = 0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                child: Column(
                  children: [
                    SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 50,
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                child: NeumorphicIcon(
                                                  Icons.keyboard_arrow_left,
                                                  size: 30,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      surfaceIntensity: 0.5,
                                                      color: TextColor(),
                                                      lightSource:
                                                          LightSource.topLeft),
                                                ),
                                              ))),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60 -
                                              160,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      '알림',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            secondTitleTextsize(),
                                                        color: TextColor(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )))
                                    ],
                                  )),
                              whatwantnotice == 1
                                  ? SizedBox(
                                      width: 50,
                                      child: InkWell(
                                          onTap: () {
                                            for (int i = 1;
                                                i <= _list_ad.length;
                                                i++) {
                                              firestore
                                                  .collection(
                                                      'AppNoticeByUsers')
                                                  .doc('$i')
                                                  .delete();
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 30,
                                            height: 30,
                                            child: NeumorphicIcon(
                                              Icons.delete,
                                              size: 30,
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.convex,
                                                  depth: 2,
                                                  surfaceIntensity: 0.5,
                                                  color: TextColor(),
                                                  lightSource:
                                                      LightSource.topLeft),
                                            ),
                                          )))
                                  : SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                            ],
                          ),
                        )),
                    NoticeApps(),
                  ],
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NoticeLists(whatwantnotice),
                              const SizedBox(
                                height: 150,
                              )
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  NoticeApps() {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          NotiBox()
        ],
      ),
    );
  }

  NotiBox() {
    return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width - 40,
        child: ListView.builder(
            // the number of items in the list
            itemCount: notinamelist.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            // display each item of the product list
            itemBuilder: (context, index) {
              return index == 1
                  ? Row(
                      children: [
                        SizedBox(
                            height: 30,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    primary: Hive.box('user_setting')
                                                .get('noti_home_click') ==
                                            null
                                        ? Colors.white
                                        : (Hive.box('user_setting')
                                                    .get('noti_home_click') ==
                                                index
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    side: BorderSide(
                                      width: 1,
                                      color: TextColor(),
                                    )),
                                onPressed: () {
                                  setState(() {
                                    Hive.box('user_setting')
                                        .put('noti_home_click', index);
                                    whatwantnotice = index;
                                  });
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          notinamelist[index],
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Hive.box('user_setting').get(
                                                        'noti_home_click') ==
                                                    null
                                                ? Colors.black45
                                                : (Hive.box('user_setting').get(
                                                            'noti_home_click') ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black45),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                            height: 30,
                            width: (MediaQuery.of(context).size.width - 40) / 4,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    primary: Hive.box('user_setting')
                                                .get('noti_home_click') ==
                                            null
                                        ? Colors.white
                                        : (Hive.box('user_setting')
                                                    .get('noti_home_click') ==
                                                index
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    side: const BorderSide(
                                      width: 1,
                                      color: Colors.black45,
                                    )),
                                onPressed: () {
                                  setState(() {
                                    Hive.box('user_setting')
                                        .put('noti_home_click', index);
                                    whatwantnotice = index;
                                  });
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          notinamelist[index],
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Hive.box('user_setting').get(
                                                        'noti_home_click') ==
                                                    null
                                                ? Colors.black45
                                                : (Hive.box('user_setting').get(
                                                            'noti_home_click') ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black45),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    );
            }));
  }

  NoticeLists(int whatwantnotice) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 160,
      width: MediaQuery.of(context).size.width - 40,
      child: SnapNotice(whatwantnotice),
    );
  }

  SnapNotice(int whatwantnotice) {
    return whatwantnotice == 0
        ? StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('AppNoticeByCompany').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _list_ad.clear();
                final valuespace = snapshot.data!.docs;
                for (var sp in valuespace) {
                  final messageText = sp.get('title');
                  final messageDate = sp.get('date');
                  _list_ad.add(PageList(
                    title: messageText,
                    sub: messageDate,
                  ));
                }

                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _list_ad.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ContainerDesign(
                                color: BGColor(),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _list_ad[index].title,
                                                      style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                )),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  _list_ad[index]
                                                      .sub
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize()),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ));
                    });
              }
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 160,
                  child: Center(
                    child: Text(
                      '공지사항이 없습니다;;;',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: secondTitleTextsize()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ));
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('AppNoticeByUsers')
                .where('username', isEqualTo: name)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _list_ad.clear();
                final valuespace = snapshot.data!.docs;
                for (var sp in valuespace) {
                  final messageText = sp.get('title');
                  final messageDate = sp.get('date');
                  _list_ad.add(PageList(title: messageText, sub: messageDate));
                }

                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _list_ad.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ContainerDesign(
                                color: BGColor(),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _list_ad[index].title,
                                                      style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                )),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  _list_ad[index]
                                                      .sub
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize()),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ));
                    });
              }
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 160,
                  child: Center(
                    child: Text(
                      '공지사항이 없습니다;;;',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: secondTitleTextsize()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ));
            },
          );
  }
}
