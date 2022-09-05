import 'package:clickbyme/DB/Expandable.dart';
import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Dialogs/checkdeletenoti.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import '../../Tool/IconBtn.dart';
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
  var userlist = [Hive.box('user_info').get('id')];
  var updateid = '';
  var updateusername = [];
  var returntitle = [];
  var returndate = [];
  final notilist = Get.put(notishow());
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
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text('알림',
                                                        style: TextStyle(
                                                          fontSize:
                                                              secondTitleTextsize(),
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ),
                                                  whatwantnotice == 1
                                                      ? IconBtn(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                final reloadpage =
                                                                    await Get.dialog(
                                                                            checkdeletenoti(context)) ??
                                                                        false;
                                                                if (reloadpage) {
                                                                  firestore
                                                                      .collection(
                                                                          'AppNoticeByUsers')
                                                                      .orderBy(
                                                                          'date')
                                                                      /*.where(
                                                                        'date',
                                                                        isEqualTo: DateFormat('yyyy-MM-dd')
                                                                            .parse(DateTime.now().toString())
                                                                            .toString()
                                                                            .split(' ')[0])*/
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    returntitle
                                                                        .clear();
                                                                    returndate
                                                                        .clear();
                                                                    value.docs
                                                                        .forEach(
                                                                            (element) {
                                                                      if (element
                                                                              .get('username')
                                                                              .toString()
                                                                              .contains(name) ==
                                                                          true) {
                                                                        updateid =
                                                                            element.id;
                                                                        updateusername =
                                                                            element.get('username');
                                                                        returntitle
                                                                            .add(element.get('title'));
                                                                        returndate
                                                                            .add(element.get('date'));
                                                                        updateusername.removeWhere((element) => element
                                                                            .toString()
                                                                            .contains(name));
                                                                        if (updateusername
                                                                            .isEmpty) {
                                                                          firestore
                                                                              .collection('AppNoticeByUsers')
                                                                              .doc(updateid)
                                                                              .delete();
                                                                        } else {
                                                                          firestore
                                                                              .collection(
                                                                                  'AppNoticeByUsers')
                                                                              .doc(
                                                                                  updateid)
                                                                              .update({
                                                                            'username':
                                                                                updateusername
                                                                          });
                                                                        }
                                                                      }
                                                                    });
                                                                  }).whenComplete(
                                                                          () {
                                                                    setState(
                                                                        () {
                                                                      Hive.box(
                                                                              'user_setting')
                                                                          .put(
                                                                              'noti_home_click',
                                                                              0);
                                                                      whatwantnotice =
                                                                          0;
                                                                    });
                                                                  });
                                                                }
                                                              },
                                                              icon: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons.delete,
                                                                  size: 30,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      surfaceIntensity:
                                                                          0.5,
                                                                      color:
                                                                          TextColor(),
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )),
                                                          color: TextColor())
                                                      : const SizedBox(
                                                          width: 0,
                                                          height: 0,
                                                        ),
                                                  whatwantnotice == 1
                                                      ? const SizedBox(
                                                          width: 10,
                                                          height: 0,
                                                        )
                                                      : const SizedBox(
                                                          width: 0,
                                                          height: 0,
                                                        ),
                                                  IconBtn(
                                                      child: IconButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          icon: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons.close,
                                                              size: 30,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  surfaceIntensity:
                                                                      0.5,
                                                                  color:
                                                                      TextColor(),
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          )),
                                                      color: TextColor())
                                                ],
                                              ))),
                                    ],
                                  )),
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NoticeLists(whatwantnotice),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [whatwantnotice == 0 ? CompanyNotice() : UserNotice()],
      ),
    );
  }

  CompanyNotice() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('AppNoticeByCompany')
          .orderBy('date')
          .snapshots(),
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

          return _list_ad.isEmpty
              ? SizedBox(
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
                  ))
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _list_ad.length,
                  shrinkWrap: true,
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
                                      height: 100,
                                      width: MediaQuery.of(context).size.width -
                                          60,
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
                                                    softWrap: true,
                                                    maxLines: 2,
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
                                                _list_ad[index].sub.toString(),
                                                style: TextStyle(
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
                                                overflow: TextOverflow.ellipsis,
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

  UserNotice() {
    return FutureBuilder(
        future: firestore
            .collection('AppNoticeByUsers')
            //.where('username', arrayContainsAny: [name])
            .orderBy('date')
            .get()
            .then(((QuerySnapshot querySnapshot) => {
                  notilist.resetnoti(),
                  querySnapshot.docs.forEach((doc) {
                    final messageText = doc.get('title');
                    final messageDate = doc.get('date');
                    if (doc.get('username').toString().contains(name)) {
                      notilist.setnoti(messageText, messageDate);
                    }
                  })
                })),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return notilist.listad.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: notilist.listad.length,
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
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
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
                                                      notilist
                                                          .listad[index].title,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
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
                                                  notilist.listad[index].sub
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
                    })
                : SizedBox(
                    height: MediaQuery.of(context).size.height - 160,
                    child: Center(
                      child: Text(
                        '알림사항이 없습니다;;;',
                        style: TextStyle(
                            color: TextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: secondTitleTextsize()),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ));
          }
          return SizedBox(
              height: MediaQuery.of(context).size.height - 160,
              child: Center(
                child: Text(
                  '알림사항이 없습니다;;;',
                  style: TextStyle(
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: secondTitleTextsize()),
                  overflow: TextOverflow.ellipsis,
                ),
              ));
        }));
    /*return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('AppNoticeByUsers')
          .where('username', arrayContainsAny: [name])
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _list_ad.clear();
          var valuespacesecond;
          valuespacesecond = snapshot.data!.docs;
          if (valuespacesecond.isNotEmpty) {
            for (var sp in valuespacesecond) {
              final messageText = sp.get('title');
              final messageDate = sp.get('date');
              _list_ad.add(PageList(title: messageText, sub: messageDate));
              /*if (sp.get('username').toString().contains(name)) {
                _list_ad.add(PageList(title: messageText, sub: messageDate));
              }*/
            }
          }
          return _list_ad.isNotEmpty
              ? ListView.builder(
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
                                      height: 100,
                                      width: MediaQuery.of(context).size.width -
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
                                                    softWrap: true,
                                                    maxLines: 2,
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
                                                _list_ad[index].sub.toString(),
                                                style: TextStyle(
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
                                                overflow: TextOverflow.ellipsis,
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
                  })
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 160,
                  child: Center(
                    child: Text(
                      '알림사항이 없습니다;;;',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: secondTitleTextsize()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ));
        }
        return SizedBox(
            height: MediaQuery.of(context).size.height - 160,
            child: Center(
              child: Text(
                '알림사항이 없습니다;;;',
                style: TextStyle(
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: secondTitleTextsize()),
                overflow: TextOverflow.ellipsis,
              ),
            ));
      },
    );*/
  }
}
