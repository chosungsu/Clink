import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/IconBtn.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';

class NotiAlarm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm>
    with WidgetsBindingObserver, TickerProviderStateMixin {
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
  final notilist = Get.put(notishow());
  final readlist = [];
  final listid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //late TabController tabController;
  int pageindex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Hive.box('user_setting').put('noti_home_click', 0);
    whatwantnotice = notilist.whatnoticepagenum;
    /*tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );*/
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      GoToMain(context);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: UI(),
      ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  IconBtn(
                                                      child: IconButton(
                                                          onPressed: () async {
                                                            final reloadpage = await Get.dialog(OSDialog(
                                                                    context,
                                                                    '경고',
                                                                    Text(
                                                                        '알림들을 삭제하시겠습니까?',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                contentTextsize(),
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                    pressed2)) ??
                                                                false;
                                                            if (reloadpage) {
                                                              firestore
                                                                  .collection(
                                                                      'AppNoticeByUsers')
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                for (var element
                                                                    in value
                                                                        .docs) {
                                                                  if (element
                                                                          .get(
                                                                              'sharename')
                                                                          .toString()
                                                                          .contains(
                                                                              name) ==
                                                                      true) {
                                                                    updateid =
                                                                        element
                                                                            .id;
                                                                    updateusername = element
                                                                        .get(
                                                                            'sharename')
                                                                        .toString()
                                                                        .split(
                                                                            ',')
                                                                        .toList();
                                                                    if (updateusername
                                                                            .length ==
                                                                        1) {
                                                                      firestore
                                                                          .collection(
                                                                              'AppNoticeByUsers')
                                                                          .doc(
                                                                              updateid)
                                                                          .delete();
                                                                    } else {
                                                                      updateusername.removeWhere((element) => element
                                                                          .toString()
                                                                          .contains(
                                                                              name));
                                                                      firestore
                                                                          .collection(
                                                                              'AppNoticeByUsers')
                                                                          .doc(
                                                                              updateid)
                                                                          .update({
                                                                        'sharename':
                                                                            updateusername
                                                                      });
                                                                    }
                                                                  } else {
                                                                    if (element
                                                                            .get('username')
                                                                            .toString() ==
                                                                        name) {
                                                                      updateid =
                                                                          element
                                                                              .id;
                                                                      firestore
                                                                          .collection(
                                                                              'AppNoticeByUsers')
                                                                          .doc(
                                                                              updateid)
                                                                          .delete();
                                                                    } else {}
                                                                  }
                                                                }
                                                              }).whenComplete(
                                                                      () {
                                                                setState(() {
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
                                                            alignment: Alignment
                                                                .center,
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons.delete,
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
                                                      color: TextColor()),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconBtn(
                                                      child: IconButton(
                                                          onPressed: () async {
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 0),
                                                                () {
                                                              GoToMain(context);
                                                            });
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
                    //NoticeApps(),
                    //whatwantnotice == 0 ? const SizedBox() : allread(),
                  ],
                ),
              ),
              //TabViewScreen(),
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
                              N_Container_1(height)
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

  /*TabViewScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: TextColor_shadowcolor(),
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: TabBar(
                onTap: (index) {
                  setState(() {
                    pageindex = index;
                  });
                },
                controller: tabController,
                labelColor: TextColor(),
                unselectedLabelColor: BGColor(),
                indicator: BoxDecoration(
                    color: BGColor(), borderRadius: BorderRadius.circular(30)),
                tabs: [
                  /*Text(
                    '공지사항',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),*/
                  Text(
                    '인앱알림',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          )),
    );
  }*/

  allread() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        allreadBox()
      ],
    );
  }

  allreadBox() {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < listid.length; i++) {
                  notilist.updatenoti(listid[i]);
                  readlist[i] = 'yes';
                }
              });
            },
            child: Text(
              '모두 읽음표시',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  decoration: TextDecoration.underline),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  N_Container_1(double height) {
    //프로버전 구매시 보이지 않게 함
    /*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //ADEvents(context)
      ],
    )*/
    return SizedBox(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '광고공간입니다',
              style: TextStyle(
                  color: TextColor_shadowcolor(),
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize()),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  NoticeLists(int whatwantnotice) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 180,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              allread(),
              UserNotice(),
            ],
          ),
        )
        /*TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          //CompanyNotice(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                allread(),
                UserNotice(),
              ],
            ),
          )
        ],
      ),*/
        );
  }

  UserNotice() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('AppNoticeByUsers')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        /*notilist.listad.sort(
          (a, b) {
            return b.sub.toString().compareTo(a.sub);
          },
        );*/
        if (snapshot.hasData) {
          notilist.listad.clear();
          listid.clear();
          readlist.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            final messageText = sp.get('title');
            final messageDate = sp.get('date');
            if (sp.get('sharename').toString().contains(name) ||
                sp.get('username') == name) {
              readlist.add(sp.get('read'));
              listid.add(sp.id);
              notilist.listad
                  .add(PageList(title: messageText, sub: messageDate));
            }
          }
          return notilist.listad.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  height: MediaQuery.of(context).size.height - 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '생성된 푸시알림이 아직 없습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor_shadowcolor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: notilist.listad.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          notilist.updatenoti(listid[index]);
                          setState(() {
                            readlist[index] = 'yes';
                          });
                          notilist.listad[index].title.toString().contains('메모')
                              ? Get.to(
                                  () => const DayNoteHome(
                                        title: '',
                                        isfromwhere: 'notihome',
                                      ),
                                  transition: Transition.rightToLeft)
                              : Get.to(
                                  () => ChooseCalendar(
                                        isfromwhere: 'notihome',
                                        index: 0,
                                      ),
                                  transition: Transition.rightToLeft);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ContainerDesign(
                              color: readlist[index] == 'no'
                                  ? BGColor()
                                  : Colors.grey.shade400,
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width -
                                          80,
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
                                                    textAlign: TextAlign.center,
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              height: MediaQuery.of(context).size.height - 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Center(child: CircularProgressIndicator())],
              ));
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: MediaQuery.of(context).size.height - 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                  '생성된 푸시알림이 아직 없습니다.',
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 3,
                    color: TextColor_shadowcolor(),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
