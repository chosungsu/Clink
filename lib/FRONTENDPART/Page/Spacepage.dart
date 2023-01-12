// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/FIREBASE/PersonalVP.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/sheets/movetolinkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../Tool/AndroidIOS.dart';
import '../Route/mainroute.dart';
import '../Route/subuiroute.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/TextSize.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Spacepage extends StatefulWidget {
  const Spacepage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SpacepageState();
}

class _SpacepageState extends State<Spacepage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  var _controller = TextEditingController();
  final searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    Hive.box('user_setting').put('page_index', 5);
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
                      color: draw.backgroundcolor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppBarCustom(
                              title: 'MY',
                              lefticon: false,
                              lefticonname: Icons.add,
                              righticon: true,
                              doubleicon: false,
                              righticonname: Ionicons.add_outline),
                          const SizedBox(
                            height: 20,
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
                                          child: LayoutBuilder(
                                            builder: ((context, constraint) {
                                              return Responsivelayout(
                                                  constraint.maxWidth,
                                                  LSView(constraint.maxHeight,
                                                      constraint.maxWidth),
                                                  PRView(constraint.maxHeight));
                                            }),
                                          )),
                                    )),
                              )),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  LSView(maxHeight, maxWidth) {
    return GetBuilder<linkspacesetting>(
        builder: (_) => StreamBuilder<QuerySnapshot>(
              stream: SpacepageStreamParent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  SpacepageChild1(snapshot);

                  return uiset.pagelist.isEmpty
                      ? Center(
                          child: NeumorphicText(
                            '텅! 비어있어요~',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: draw.color_textstatus,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: maxWidth > 1100
                                  ? 30.w
                                  : (maxWidth > 650 ? 50.w : 100.w),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: maxWidth > 1100
                                  ? 2 / 1
                                  : (maxWidth > 650 ? 5 / 1 : 3 / 1),
                            ),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: uiset.pagelist.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  uiset.setmypagelistindex(index);
                                  StatusBarControl.setColor(BGColor(),
                                      animated: true);
                                  draw.setnavi();
                                  Hive.box('user_setting').put('page_index', 0);
                                  Get.back();
                                },
                                child: ContainerDesign(
                                    color: draw.backgroundcolor,
                                    child: Column(children: [
                                      SizedBox(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                uiset.pagelist[index].title,
                                                softWrap: true,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color:
                                                        draw.color_textstatus,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
                                                overflow: TextOverflow.ellipsis,
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
                                              color: draw.color_textstatus,
                                            ),
                                          )
                                        ],
                                      ))
                                    ])),
                              );
                            },
                          ),
                        );
                }
                return LinearProgressIndicator(
                  backgroundColor: draw.backgroundcolor,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ));
  }

  PRView(maxHeight) {
    return GetBuilder<linkspacesetting>(
        builder: (_) => StreamBuilder<QuerySnapshot>(
              stream: SpacepageStreamParent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  SpacepageChild1(snapshot);

                  return uiset.pagelist.isEmpty
                      ? Center(
                          child: NeumorphicText(
                            '텅! 비어있어요~',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: draw.color_textstatus,
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
                                          color: draw.backgroundcolor,
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
                                                          color: draw
                                                              .color_textstatus,
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
                                                        draw.color_textstatus,
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
                  backgroundColor: draw.backgroundcolor,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ));
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      draw.setnavi();
      Hive.box('user_setting').put('page_index', 0);
      Get.to(
          () => const mainroute(
                index: 0,
              ),
          transition: Transition.downToUp);
      //Get.back();
    });
    return false;
  }
}
