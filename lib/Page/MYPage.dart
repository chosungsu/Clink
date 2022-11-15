// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/DB/Linkpage.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../DB/PageList.dart';
import '../Route/subuiroute.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Loader.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../mongoDB/mongodatabase.dart';
import '../sheets/linksettingsheet.dart';
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
  final updateid = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  final searchNode = FocusNode();
  var scrollController;
  var _controller = TextEditingController();
  late FToast fToast;
  final scollection = Get.put(selectcollection());
  final linkspaceset = Get.put(linkspacesetting());
  late Animation animation;
  String usercode = Hive.box('user_setting').get('usercode');
  final List<Linkpage> listpinlink = [];
  final List<CompanyPageList> listcompanytousers = [];
  var url;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    listpinlink.clear();
    uiset.showtopbutton = false;
    uiset.searchpagemove = '';
    Hive.box('user_setting').put('page_index', 0);
    uiset.mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
    fToast = FToast();
    fToast.init(context);
    scrollController = ScrollController();
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
    return Scaffold(
        backgroundColor: BGColor(),
        floatingActionButton: Speeddialmemo(
            context,
            usercode,
            _controller,
            searchNode,
            scrollController,
            isDialOpen,
            uiset.pagelist.isEmpty ? '빈 스페이스' : uiset.pagelist[0].title),
        body: SafeArea(
          child: GetBuilder<navibool>(
            builder: (_) => draw.navi == 0
                ? (draw.drawopen == true
                    ? Stack(
                        children: [
                          SizedBox(
                            width: 80,
                            child: DrawerScreen(
                              index: Hive.box('user_setting').get('page_index'),
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
          ),
        ));
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
                          GetBuilder<uisetting>(
                            builder: (_) => AppBarCustom(
                              title: 'MY',
                              righticon: true,
                              iconname: Icons.notifications_none,
                              textEditingController: _controller,
                              focusNode: searchNode,
                              myindex: uiset.mypagelistindex,
                            ),
                          ),
                          ScrollConfiguration(
                              behavior: NoBehavior(),
                              child: listy_My(
                                  uiset.pagelist[uiset.mypagelistindex].title))
                        ],
                      )),
                ),
              ),
            )));
  }
}
