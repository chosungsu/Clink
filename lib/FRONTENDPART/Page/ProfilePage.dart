// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Enums/Variables.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../../sheets/addgroupmember.dart';
import '../../sheets/settingpagesheets.dart';
import '../../sheets/userinfotalk.dart';
import '../UI(Widget/ShowLicense.dart';
import 'DrawerScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  var _controller = TextEditingController();
  late final PageController _pController2;
  ScrollController scrollController = ScrollController();
  late FToast fToast;
  final searchNode = FocusNode();
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
    uiset.searchpagemove = '';
    fToast = FToast();
    fToast.init(context);
    Hive.box('user_setting').put('page_index', 3);
    _controller = TextEditingController();
    _pController2 = PageController(initialPage: 0, viewportFraction: 1);
  }

  @override
  void dispose() {
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
    _pController2.dispose();
    scrollController.dispose();
    //notilist.noticontroller.dispose();
  }

  Future<void> _getAppInfo() async {
    info = await PackageInfo.fromPlatform();
    versioninfo = info.version;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: BGColor(),
          body: GetBuilder<navibool>(
              builder: (_) => draw.drawopen == true
                  ? Stack(
                      children: [
                        draw.navi == 0
                            ? Positioned(
                                left: 0,
                                child: SizedBox(
                                  width: 80,
                                  child: DrawerScreen(
                                    index: Hive.box('user_setting')
                                        .get('page_index'),
                                  ),
                                ),
                              )
                            : Positioned(
                                right: 0,
                                child: SizedBox(
                                  width: 80,
                                  child: DrawerScreen(
                                    index: Hive.box('user_setting')
                                        .get('page_index'),
                                  ),
                                ),
                              ),
                        ProfileBody(context),
                      ],
                    )
                  : Stack(
                      children: [
                        ProfileBody(context),
                      ],
                    ))),
    );
  }

  Widget ProfileBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                    ..scale(draw.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  searchNode.unfocus();
                  draw.drawopen == true
                      ? setState(() {
                          draw.drawopen = false;
                          draw.setclose();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: SizedBox(
                  height: height,
                  child: Container(
                      color: BGColor(),
                      child: Column(
                        children: [
                          AppBarCustom(
                            title: '',
                            lefticon: false,
                            lefticonname: Icons.add,
                            righticon: true,
                            doubleicon: false,
                            righticonname: Icons.person_outline,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: ScrollConfiguration(
                                behavior: NoBehavior(),
                                child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: StatefulBuilder(
                                        builder: (_, StateSetter setState) {
                                      return ExpandablePageView.builder(
                                        physics: const ScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        controller: _pController2,
                                        itemCount: draw.currentpage,
                                        onPageChanged: ((value) {
                                          setState(() {
                                            showsharegroups = false;
                                            _getAppInfo();
                                            if (value == 0) {
                                              draw.currentpage = 1;
                                            } else {}
                                          });
                                        }),
                                        itemBuilder: ((context, index) {
                                          return index == 0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 20, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      OptionChoice(
                                                          height, context),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ))
                                              : (pagesetnumber == 1
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 0, 20, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          T_Container0(height),
                                                        ],
                                                      ))
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 0, 20, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          G_Container1(height),
                                                        ],
                                                      )));
                                        }),
                                      );
                                    })),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ));
  }

  T_Container0(double height) {
    final List eventtitle = [];
    final List eventcontent = [];
    final List eventsmallcontent = [];
    final List eventstates = [];
    final List dates = [];
    return SizedBox(
      height: draw.navi == 0
          ? MediaQuery.of(context).size.height - 80 - 20 - 90
          : MediaQuery.of(context).size.height - 80 - 70 - 20 - 90,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder(
              future: firestore
                  .collection("AppNoticeByCompany")
                  .orderBy('date', descending: true)
                  .get()
                  .then(((QuerySnapshot querySnapshot) {
                for (int j = 0; j < querySnapshot.docs.length; j++) {
                  eventtitle.add(querySnapshot.docs[j].get('title'));
                  eventcontent.add(querySnapshot.docs[j].get('content'));
                  eventstates.add(querySnapshot.docs[j].get('state'));
                  eventsmallcontent.add(querySnapshot.docs[j].get('summaries'));
                  dates.add(querySnapshot.docs[j].get('date'));
                }
              })),
              builder: (context, future) => future.connectionState ==
                      ConnectionState.waiting
                  ? SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '릴리즈 노트를 불러오고 있습니다...',
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: TextColor(),
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
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: eventtitle.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: ContainerDesign(
                                  color: Colors.blue.shade200,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  backgroundColor: BGColor(),
                                                  child: Icon(
                                                    Icons.new_releases,
                                                    color:
                                                        TextColor_shadowcolor(),
                                                  ),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                eventtitle[index].toString() +
                                                    ' 릴리즈노트',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                    color: TextColor()),
                                              ),
                                            ),
                                            versioninfo !=
                                                    eventtitle[index].toString()
                                                ? InkWell(
                                                    onTap: () {
                                                      if (eventstates[index]
                                                              .toString() ==
                                                          'workingnow') {
                                                        Snack.snackbars(
                                                            context: context,
                                                            title:
                                                                '다음 업데이트를 기대해주세요',
                                                            backgroundcolor:
                                                                Colors.green,
                                                            bordercolor: draw
                                                                .backgroundcolor);
                                                      } else {
                                                        StoreRedirect.redirect(
                                                          androidAppId:
                                                              'com.jss.habittracker', // Android app bundle package name
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor(),
                                                          child: Icon(
                                                            Icons.play_for_work,
                                                            color: Colors
                                                                .red.shade400,
                                                          ),
                                                        )),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Snack.snackbars(
                                                          context: context,
                                                          title: '현재 버전입니다',
                                                          backgroundcolor:
                                                              Colors.green,
                                                          bordercolor: draw
                                                              .backgroundcolor);
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor(),
                                                          child: Icon(
                                                            Icons.verified,
                                                            color: Colors
                                                                .green.shade400,
                                                          ),
                                                        ))),
                                          ],
                                        ),
                                        Divider(
                                          height: 20,
                                          color: TextColor_shadowcolor(),
                                          thickness: 1,
                                          indent: 10.0,
                                          endIndent: 10.0,
                                        ),
                                        ListView.builder(
                                            physics: const ScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                eventcontent[index].length,
                                            itemBuilder: ((context, index2) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                BGColor(),
                                                            child: Icon(
                                                              Icons.tag,
                                                              color:
                                                                  TextColor_shadowcolor(),
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          eventcontent[index]
                                                              [index2],
                                                          maxLines: 2,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize(),
                                                              color:
                                                                  TextColor(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    eventsmallcontent[index]
                                                        [index2],
                                                    maxLines: 3,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize(),
                                                        color: TextColor(),
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            })),
                                        Divider(
                                          height: 20,
                                          color: TextColor_shadowcolor(),
                                          thickness: 1,
                                          indent: 10.0,
                                          endIndent: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                dates[index].toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                    color: TextColor()),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }

  G_Container1(double height) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('전체',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: TextColor(),
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            '유저이름을 클릭하여 프로필 확인',
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: TextColor(),
            ),
          ),
          G_Container1_body()
        ],
      ),
    );
  }

  G_Container1_body() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('PeopleList').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          friendnamelist.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            if (sp.id == name) {
              for (int i = 0; i < sp.get('friends').length; i++) {
                friendnamelist.add(sp.get('friends')[i]);
              }
            }
          }
          friendnamelist.sort(((a, b) {
            return a.toString().compareTo(b.toString());
          }));
          return friendnamelist.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: draw.navi == 0
                      ? MediaQuery.of(context).size.height - 80 - 20 - 20 - 130
                      : MediaQuery.of(context).size.height -
                          80 -
                          70 -
                          20 -
                          20 -
                          130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '친구리스트가 비어있습니다.',
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
              : SizedBox(
                  height: draw.navi == 0
                      ? MediaQuery.of(context).size.height - 80 - 20 - 20 - 130
                      : MediaQuery.of(context).size.height -
                          80 -
                          70 -
                          20 -
                          20 -
                          130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: friendnamelist.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    userinfotalk(
                                        context, index, friendnamelist);
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      decoration: BoxDecoration(
                                          color: BGColor(),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.blue.shade200)),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 25,
                                                width: 25,
                                                child: Text(
                                                    friendnamelist[index]
                                                        .toString()
                                                        .substring(0, 1),
                                                    style: TextStyle(
                                                        color:
                                                            BGColor_shadowcolor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                                decoration: BoxDecoration(
                                                  color:
                                                      TextColor_shadowcolor(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  friendnamelist[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: TextColor()),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }),
                    ],
                  ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: draw.navi == 0
                  ? MediaQuery.of(context).size.height - 80 - 20 - 20 - 130
                  : MediaQuery.of(context).size.height -
                      80 -
                      70 -
                      20 -
                      20 -
                      130,
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Center(child: CircularProgressIndicator())],
              ));
        }
        return SizedBox(
          height: draw.navi == 0
              ? MediaQuery.of(context).size.height - 80 - 20 - 20 - 130
              : MediaQuery.of(context).size.height - 80 - 70 - 20 - 20 - 130,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                  '친구리스트가 비어있습니다.',
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

  S_Container0(double height) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('설정',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: secondTitleTextsize(),
                color: TextColor(),
              )),
        ],
      ),
    );
  }

  OptionChoice(double height, BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OptView1(),
            const SizedBox(
              height: 20,
            ),
            OptView2(),
            const SizedBox(
              height: 20,
            ),
            OptView3(),
            const SizedBox(
              height: 20,
            ),
            OptView4(),
            const SizedBox(
              height: 20,
            ),
            OptView5(),
          ],
        ),
      ),
    );
  }

  OptView1() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: draw.backgroundcolor,
                      foregroundColor: draw.backgroundcolor,
                      child: Icon(
                        Icons.tune,
                        color: draw.color_textstatus,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'profilepagetitleone'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: draw.color_textstatus),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt1_body()
          ],
        ),
        color: draw.backgroundcolor,
      ),
    );
  }

  Opt1_body() {
    final List<String> list_app_setting = <String>[
      'profilepagetitleonebyone'.tr,
      'profilepagetitleonebytwo'.tr,
      'profilepagetitleonebythird'.tr,
    ];
    return GetBuilder<navibool>(
        builder: (_) => SizedBox(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list_app_setting.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  list_app_setting[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: TextColor()),
                                ),
                              ),
                              index == 0
                                  ? SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                  height: 30,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Hive.box('user_setting')
                                                            .put(
                                                                'which_color_background',
                                                                0);
                                                        draw.setnavicolor();
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Hive.box('user_setting')
                                                                      .get(
                                                                          'which_color_background') ==
                                                                  0 ||
                                                              Hive.box('user_setting')
                                                                      .get(
                                                                          'which_color_background') ==
                                                                  null
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Hive.box('user_setting').get('which_color_background') == 0 ||
                                                                              Hive.box('user_setting').get('which_color_background') ==
                                                                                  null
                                                                          ? Colors
                                                                              .blue
                                                                              .shade400
                                                                          : BGColor_shadowcolor())),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons.check,
                                                                size: 25,
                                                                style: NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade300,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                  ))),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                  height: 30,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Hive.box('user_setting')
                                                            .put(
                                                                'which_color_background',
                                                                1);
                                                        draw.setnavicolor();
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      child: Hive.box('user_setting')
                                                                  .get(
                                                                      'which_color_background') ==
                                                              1
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Hive.box('user_setting').get('which_color_background') ==
                                                                              1
                                                                          ? Colors
                                                                              .blue
                                                                              .shade400
                                                                          : BGColor_shadowcolor())),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons.check,
                                                                size: 25,
                                                                style: NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade300,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                    )
                                  : (index == 1
                                      ? SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'which_text_size',
                                                                    0);
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor_shadowcolor(),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Hive.box('user_setting').get('which_text_size') ==
                                                                                0 ||
                                                                            Hive.box('user_setting').get('which_text_size') ==
                                                                                null
                                                                        ? Colors
                                                                            .blue
                                                                            .shade400
                                                                        : BGColor_shadowcolor())),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons.format_size,
                                                              size: 15,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade300,
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'which_text_size',
                                                                    1);
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor_shadowcolor(),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Hive.box('user_setting').get('which_text_size') ==
                                                                            1
                                                                        ? Colors
                                                                            .blue
                                                                            .shade400
                                                                        : BGColor_shadowcolor())),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons.text_fields,
                                                              size: 25,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade300,
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 30,
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'which_menu_pick',
                                                                    0);
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'page_index',
                                                                    3);
                                                            uiset.setpageindex(Hive
                                                                    .box(
                                                                        'user_setting')
                                                                .get(
                                                                    'page_index'));
                                                            draw.setnavi();
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor_shadowcolor(),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: draw.navi ==
                                                                            0
                                                                        ? Colors
                                                                            .blue
                                                                            .shade400
                                                                        : BGColor_shadowcolor())),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons
                                                                  .align_horizontal_left,
                                                              size: 25,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade300,
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'which_menu_pick',
                                                                    1);
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'page_index',
                                                                    3);
                                                            uiset.setpageindex(Hive
                                                                    .box(
                                                                        'user_setting')
                                                                .get(
                                                                    'page_index'));
                                                            draw.setnavi();
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor_shadowcolor(),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: draw.navi ==
                                                                            1
                                                                        ? Colors
                                                                            .blue
                                                                            .shade400
                                                                        : BGColor_shadowcolor())),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons
                                                                  .align_horizontal_right,
                                                              size: 25,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade300,
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'which_menu_pick',
                                                                    2);
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'page_index',
                                                                    3);
                                                            uiset.setpageindex(Hive
                                                                    .box(
                                                                        'user_setting')
                                                                .get(
                                                                    'page_index'));
                                                            draw.setnavi();
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor_shadowcolor(),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: draw.navi ==
                                                                            2
                                                                        ? Colors
                                                                            .blue
                                                                            .shade400
                                                                        : BGColor_shadowcolor())),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons
                                                                  .align_vertical_bottom,
                                                              size: 25,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade300,
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                        ))
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ));
  }

  OptView2() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: draw.backgroundcolor,
                      foregroundColor: draw.backgroundcolor,
                      child: Icon(
                        Icons.campaign,
                        color: draw.color_textstatus,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'profilepagetitletwo'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: draw.color_textstatus),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt2_body()
          ],
        ),
        color: draw.backgroundcolor,
      ),
    );
  }

  Opt2_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return index == 0
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var url = Uri.parse(
                              'https://linkaiteam.github.io/LINKAITEAM/전체');
                          launchUrl(url);
                        },
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'profilepagetitletwobyone'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: TextColor()),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: TextColor(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          showreadycontent(context);
                        },
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'profilepagetitletwobytwo'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: TextColor()),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: TextColor(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
          }),
    );
  }

  OptView3() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: draw.backgroundcolor,
                      foregroundColor: draw.backgroundcolor,
                      child: Icon(
                        Icons.help_center,
                        color: draw.color_textstatus,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'profilepagetitlethird'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: draw.color_textstatus),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt3_body()
          ],
        ),
        color: draw.backgroundcolor,
      ),
    );
  }

  Opt3_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      pagesetnumber = 1;
                      draw.currentpage = 2;
                      scrollToTop(scrollController);
                      _pController2.animateToPage(1,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeIn);
                    });
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'profilepagetitlethirdbyone'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: TextColor()),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: TextColor(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  OptView4() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: draw.backgroundcolor,
                      foregroundColor: draw.backgroundcolor,
                      child: Icon(
                        Icons.groups,
                        color: draw.color_textstatus,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'profilepagetitleforth'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: draw.color_textstatus),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt4_body()
          ],
        ),
        color: draw.backgroundcolor,
      ),
    );
  }

  Opt4_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Column(
              children: [
                (index == 0
                    ? GestureDetector(
                        onTap: () async {
                          addgroupmember(
                              context, searchNode, _controller, peopleadd.code);
                        },
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'profilepagetitleforthbyone'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: TextColor()),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: TextColor(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            pagesetnumber = 2;
                            draw.currentpage = 2;
                            scrollToTop(scrollController);
                            _pController2.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          });
                        },
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'profilepagetitleforthbytwo'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: TextColor()),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: TextColor(),
                              ),
                            ],
                          ),
                        ),
                      ))
              ],
            );
          }),
    );
  }

  OptView5() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: draw.backgroundcolor,
                      foregroundColor: draw.backgroundcolor,
                      child: Icon(
                        Icons.portrait,
                        color: draw.color_textstatus,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'profilepagetitlefifth'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: draw.color_textstatus),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt5_body()
          ],
        ),
        color: draw.backgroundcolor,
      ),
    );
  }

  Opt5_body() {
    final List<String> list_user_setting = <String>[
      'profilepagetitlefifthbyone'.tr,
      'profilepagetitlefifthbytwo'.tr,
    ];
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list_user_setting.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (index == 0) {
                      var url = Uri.parse(
                          'https://linkaiteam.github.io/LINKAITEAM/개인정보처리방침');
                      launchUrl(url);
                    } else {
                      Get.to(() => const ShowLicense(),
                          transition: Transition.rightToLeft);
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list_user_setting[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: TextColor()),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: TextColor(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
