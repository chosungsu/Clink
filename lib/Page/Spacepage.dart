// ignore_for_file: non_constant_identifier_names

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/sheets/movetolinkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/PageList.dart';
import '../Route/subuiroute.dart';
import '../Tool/AppBarCustom.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';
import '../mongoDB/mongodatabase.dart';

class Spaceapage extends StatefulWidget {
  const Spaceapage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SpaceapageState();
}

class _SpaceapageState extends State<Spaceapage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  String name = Hive.box('user_info').get('id');
  String usercode = Hive.box('user_setting').get('usercode');
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var _controller = TextEditingController();
  final searchNode = FocusNode();
  late Animation animation;
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    draw.navi = 1;
    uiset.currentstepper = 0;
    Hive.box('user_setting').put('page_index', 3);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGColor(),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: UI(),
          ),
        ));
  }

  UI() {
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppBarCustom(
                            title: 'MY',
                            righticon: true,
                            iconname: Icons.add_box,
                          ),
                          Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                child: ScrollConfiguration(
                                    behavior: NoBehavior(),
                                    child: SingleChildScrollView(
                                      physics: const ScrollPhysics(),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        child: Pagination(),
                                      ),
                                    )),
                              )),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  Pagination() {
    return Column(
      children: [choosecategory()],
    );
  }

  choosecategory() {
    return GetBuilder<linkspacesetting>(
        builder: (_) => StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Pinchannel').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  uiset.pagelist.clear();
                  final valuespace = snapshot.data!.docs;
                  for (var sp in valuespace) {
                    final messageuser = sp.get('username');
                    final messagetitle = sp.get('linkname');
                    if (messageuser == usercode) {
                      uiset.pagelist.add(
                          PageList(title: messagetitle, username: messageuser));
                    }
                  }

                  return uiset.pagelist.isEmpty
                      ? Center(
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
                        )
                      : SizedBox(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: uiset.pagelist.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        uiset.setmypagelistindex(index);
                                        StatusBarControl.setColor(BGColor(),
                                            animated: true);
                                        draw.setnavi();
                                        Hive.box('user_setting')
                                            .put('page_index', 0);
                                        Get.back();
                                      },
                                      child: ContainerDesign(
                                          color: Colors.transparent,
                                          child: Column(children: [
                                            SizedBox(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      uiset.pagelist[index]
                                                          .title,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    settingseparatedlinkspace(
                                                        context,
                                                        uiset.pagelist,
                                                        _controller,
                                                        searchNode,
                                                        index);
                                                  },
                                                  child: Icon(
                                                    Icons.more_horiz,
                                                    color:
                                                        TextColor_shadowcolor(),
                                                  ),
                                                )
                                              ],
                                            ))
                                          ])),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }),
                        );
                }
                return LinearProgressIndicator(
                  backgroundColor: BGColor(),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ));
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(BGColor(), animated: true);
      draw.setnavi();
      Hive.box('user_setting').put('page_index', 0);
      Get.back();
    });
    return false;
  }
}
