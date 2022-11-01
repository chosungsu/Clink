import 'package:clickbyme/DB/Linkpage.dart';
import 'package:clickbyme/Page/Linkin.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../DB/PageList.dart';
import '../Route/subuiroute.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Loader.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../mongoDB/mongodatabase.dart';
import '../sheets/movetolinkspace.dart';
import 'DrawerScreen.dart';

class MYPage extends StatefulWidget {
  const MYPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> with TickerProviderStateMixin {
  bool login_state = false;
  String name = Hive.box('user_info').get('id');
  final draw = Get.put(navibool());
  final notilist = Get.put(notishow());
  final cal_share_person = Get.put(PeopleAdd());
  final uiset = Get.put(uisetting());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sharelist = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  final searchNode = FocusNode();
  var scrollController;
  var _controller = TextEditingController();
  late FToast fToast;
  final scollection = Get.put(selectcollection());
  late Animation animation;
  String usercode = Hive.box('user_setting').get('usercode');
  final List<Linkpage> listpinlink = [];
  final List<PageList> listcompanytousers = [];
  var url;
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    super.initState();
    listpinlink.clear();
    Hive.box('user_setting').put('page_index', 1);
    fToast = FToast();
    fToast.init(context);
    _controller = TextEditingController();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (scrollController.offset >= 150) {
            uiset.showtopbutton = true; // show the back-to-top button
          } else {
            uiset.showtopbutton = false; // hide the back-to-top button
          }
        });
      });
  }

  @override
  void dispose() {
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
    scrollController.dispose();
    //notilist.noticontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            floatingActionButton: uiset.showtopbutton == false
                ? null
                : FloatingActionButton(
                    onPressed: (() {
                      scrollToTop(scrollController);
                    }),
                    backgroundColor: BGColor(),
                    child: Icon(
                      Icons.arrow_upward,
                      color: TextColor(),
                    ),
                  ),
            body: GetBuilder<navibool>(
              builder: (_) => draw.navi == 0
                  ? (draw.drawopen == true
                      ? Stack(
                          children: [
                            SizedBox(
                              width: 80,
                              child: DrawerScreen(
                                index:
                                    Hive.box('user_setting').get('page_index'),
                              ),
                            ),
                            GroupBody(context),
                            uiset.loading == true
                                ? const Loader(
                                    wherein: 'route',
                                  )
                                : Container()
                          ],
                        )
                      : Stack(
                          children: [
                            GroupBody(context),
                            uiset.loading == true
                                ? const Loader(
                                    wherein: 'route',
                                  )
                                : Container()
                          ],
                        ))
                  : Stack(
                      children: [
                        GroupBody(context),
                        uiset.loading == true
                            ? const Loader(
                                wherein: 'route',
                              )
                            : Container()
                      ],
                    ),
            )));
  }

  Widget GroupBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
              ..scale(draw.scalefactor),
            duration: const Duration(milliseconds: 250),
            child: GetBuilder<navibool>(
              builder: (_) => GestureDetector(
                onTap: () {
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
                          const AppBarCustom(
                            title: '',
                            righticon: false,
                            iconname: Icons.search,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: ScrollConfiguration(
                                behavior: NoBehavior(),
                                child: SingleChildScrollView(
                                    controller: scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    child: StatefulBuilder(
                                        builder: (_, StateSetter setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FutureBuilder(
                                              future: MongoDB.getData(
                                                      collectionname:
                                                          'companynotice')
                                                  .then((value) {
                                                for (int j = 0;
                                                    j < value.length;
                                                    j++) {
                                                  final messageText =
                                                      value[j]['title'];
                                                  final messageDate =
                                                      value[j]['date'];
                                                  final messageyes =
                                                      value[j]['showthisinapp'];
                                                  final messagewhere =
                                                      value[j]['where'];
                                                  if (messageyes == 'yes' &&
                                                      messagewhere ==
                                                          'template') {
                                                    listcompanytousers
                                                        .add(PageList(
                                                      title: messageText,
                                                      sub: messageDate,
                                                    ));
                                                    url = Uri.parse(
                                                        value[j]['url']);
                                                    uiset.seteventspace(
                                                        listcompanytousers[0]
                                                            .title,
                                                        value[j]['url']);
                                                  }
                                                }
                                              }),
                                              builder: ((context, snapshot) {
                                                return CompanyNotice(
                                                    'template',
                                                    serverstatus,
                                                    uiset.eventtitle,
                                                    uiset.eventurl);
                                              })),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ADSHOW(height),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          M_Container0(height),
                                        ],
                                      );
                                    })),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            )));
  }

  M_Container0(double height) {
    final link = [];

    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: RichText(
                        text: TextSpan(children: [
                      WidgetSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: contentTextsize(),
                              color: TextColor_shadowcolor()),
                          child: GestureDetector(
                            onTap: () => movetolinkspace(context),
                            child: Row(
                              children: [
                                Text(
                                  'MY LINK',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize(),
                                      color: TextColor()),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.swap_horiz,
                                  color: TextColor_shadowcolor(),
                                ),
                              ],
                            ),
                          )),
                    ])),
                  ),
                  InkWell(
                    onTap: () => movetolinkspace(context),
                    child: Icon(
                      Icons.search,
                      color: TextColor_shadowcolor(),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: contentTextsize(),
                            decoration: TextDecoration.underline,
                            color: TextColor_shadowcolor()),
                        child: GestureDetector(
                          onTap: () => addmylink(context, usercode, _controller,
                              searchNode, scollection),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: TextColor_shadowcolor(),
                              ),
                              Text(
                                '추가하기',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: contentTextsize(),
                                    color: TextColor_shadowcolor()),
                              ),
                            ],
                          ),
                        )),
                  ])),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /*GetBuilder<selectcollection>(builder: ((controller) {
                  return SizedBox(
                      height: 50,
                      child: FutureBuilder(
                        future: MongoDB.getData(collectionname: 'linknet')
                            .then((value) {
                          scollection.resetcollectionlink();
                          for (int j = 0; j < value.length; j++) {
                            link.clear();
                            final user = value[j]['username'];

                            if (user == usercode) {
                              for (int i = 0;
                                  i < value[j]['link'].length;
                                  i++) {
                                link.add(value[j]['link'][i]);
                                scollection.addmemolistlink(link[i]);
                              }
                            }
                          }
                        }),
                        builder: (context, snapshot) {
                          return scollection.collectionlink.isEmpty
                              ? ContainerDesign(
                                  color: Colors.grey.shade300,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              '추가버튼으로 추가하세요',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: scollection.collectionlink.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey.shade200,
                                            ),
                                            child: SizedBox(
                                              width: 80,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        scollection
                                                            .collectionlink[
                                                                index]
                                                            .toString(),
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    );
                                  }));
                        },
                      ));
                }))*/
            serverstatus == true
                ? FutureBuilder(
                    future: MongoDB.getData(collectionname: 'linknet')
                        .then((value) {
                      listpinlink.clear();
                      if (value.isEmpty) {
                      } else {
                        for (int j = 0; j < value.length; j++) {
                          final user = value[j]['username'];
                          if (user == usercode) {
                            for (int i = 0; i < value[j]['link'].length; i++) {
                              listpinlink
                                  .add(Linkpage(link: value[j]['link'][i]));
                            }
                          }
                        }
                      }
                    }),
                    builder: (context, snapshot) {
                      return listpinlink.isEmpty
                          ? SizedBox(
                              child: Center(
                              child: NeumorphicText(
                                '텅! 비어있어요~',
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
                            ))
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          childAspectRatio: 3 / 1,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemCount: listpinlink.length,
                                  itemBuilder: ((context, index) {
                                    return GestureDetector(
                                        onTap: () async {},
                                        child: FocusedMenuHolder(
                                            menuItems: [
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.style,
                                                    size: 30,
                                                  ),
                                                  title: Text('상세정보',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () async {}),
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.share,
                                                    size: 30,
                                                  ),
                                                  title: Text('Sharing 설정',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () async {}),
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.edit,
                                                    size: 30,
                                                  ),
                                                  backgroundColor:
                                                      Colors.red.shade200,
                                                  title: Text('변경 및 삭제',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () async {
                                                    SetChangeLink(
                                                        context,
                                                        _controller,
                                                        searchNode,
                                                        fToast,
                                                        listpinlink[index]
                                                            .link);
                                                  }),
                                            ],
                                            duration:
                                                const Duration(seconds: 0),
                                            animateMenuItems: true,
                                            menuOffset: 20,
                                            bottomOffsetHeight: 10,
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            openWithTap: false,
                                            onPressed: () {
                                              index == 0
                                                  ? Get.to(
                                                      () =>
                                                          const ChooseCalendar(
                                                              isfromwhere:
                                                                  'mypagehome',
                                                              index: 0),
                                                      transition: Transition
                                                          .rightToLeft)
                                                  : Get.to(
                                                      () => const Linkin(
                                                            isfromwhere:
                                                                'mypagehome',
                                                          ),
                                                      transition: Transition
                                                          .rightToLeft);
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.grey.shade200,
                                                ),
                                                child: SizedBox(
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                      Flexible(
                                                          fit: FlexFit.tight,
                                                          child: Text(
                                                            listpinlink[index]
                                                                .link
                                                                .toString(),
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize()),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ))
                                                    ])))));
                                  })));
                    },
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('Linknet').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        listpinlink.clear();
                        final valuespace = snapshot.data!.docs;
                        for (var sp in valuespace) {
                          final user = sp.get('username');
                          if (user == usercode) {
                            for (int i = 0; i < sp.get('link').length; i++) {
                              listpinlink
                                  .add(Linkpage(link: sp.get('link')[i]));
                            }
                          }
                        }
                        return listpinlink.isEmpty
                            ? SizedBox(
                                child: Center(
                                child: NeumorphicText(
                                  '텅! 비어있어요~',
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
                              ))
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: 3 / 1,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    itemCount: listpinlink.length,
                                    itemBuilder: ((context, index) {
                                      return GestureDetector(
                                          onTap: () async {},
                                          child: FocusedMenuHolder(
                                              menuItems: [
                                                FocusedMenuItem(
                                                    trailingIcon: const Icon(
                                                      Icons.style,
                                                      size: 30,
                                                    ),
                                                    title: Text('상세정보',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                    onPressed: () async {}),
                                                FocusedMenuItem(
                                                    trailingIcon: const Icon(
                                                      Icons.share,
                                                      size: 30,
                                                    ),
                                                    title: Text('Sharing 설정',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                    onPressed: () {
                                                      //공유자 검색
                                                    }),
                                              ],
                                              duration:
                                                  const Duration(seconds: 0),
                                              animateMenuItems: true,
                                              menuOffset: 20,
                                              bottomOffsetHeight: 10,
                                              menuWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              openWithTap: false,
                                              onPressed: () {},
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  child: SizedBox(
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                        Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Text(
                                                              listpinlink[index]
                                                                  .link
                                                                  .toString(),
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize()),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ))
                                                      ])))));
                                    })));
                      }
                      return LinearProgressIndicator(
                        backgroundColor: BGColor(),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      );
                    },
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  addmylink(
    BuildContext context,
    String username,
    TextEditingController textEditingController_add_sheet,
    FocusNode searchNode_add_section,
    selectcollection scollection,
  ) {
    Get.bottomSheet(
            Container(
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            searchNode_add_section.unfocus();
                          });
                        },
                        child: linkstation(
                            context,
                            textEditingController_add_sheet,
                            searchNode_add_section,
                            scollection,
                            username),
                      ))),
            ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
        .whenComplete(() {
      textEditingController_add_sheet.clear();
    });
  }

  /*M_Container0(double height) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => const ChooseCalendar(
                  isfromwhere: 'mypagehome',
                  index: 0,
                ),
            transition: Transition.rightToLeft);
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('캘린더 모음',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor_shadowcolor(),
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  child: NeumorphicIcon(
                    Icons.shortcut,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        surfaceIntensity: 0.5,
                        depth: 2,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                ),
              ],
            ),
            Text(
              '우측아이콘을 클릭하여 캘린더 확인',
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: TextColor(),
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 1,
              indent: 10.0,
              endIndent: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  M_Container1(double height) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => const DayNoteHome(
                  title: '',
                  isfromwhere: 'mypagehome',
                ),
            transition: Transition.rightToLeft);
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('메모장 모음',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor_shadowcolor(),
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  child: NeumorphicIcon(
                    Icons.shortcut,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        surfaceIntensity: 0.5,
                        depth: 2,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                ),
              ],
            ),
            Text(
              '우측아이콘을 클릭하여 메모 확인',
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: TextColor(),
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 1,
              indent: 10.0,
              endIndent: 10.0,
            ),
          ],
        ),
      ),
    );
  }*/
}
