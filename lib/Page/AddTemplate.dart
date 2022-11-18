// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/PageList.dart';
import '../Enums/Variables.dart';
import '../Route/subuiroute.dart';
import '../Tool/AppBarCustom.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/category.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';
import '../sheets/linksettingsheet.dart';

class AddTemplate extends StatefulWidget {
  const AddTemplate({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<StatefulWidget> createState() => _AddTemplateState();
}

class _AddTemplateState extends State<AddTemplate>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  final cg = Get.put(category());
  final linkspaceset = Get.put(linkspacesetting());
  var _controller = TextEditingController();
  final searchNode = FocusNode();
  List spaceindata = [];

  @override
  void initState() {
    super.initState();
    draw.navi = 1;
    uiset.currentstepper = 0;
    cg.categorypicknumber = 99;
    Hive.box('user_setting').put('page_index', 3);
    WidgetsBinding.instance.addObserver(this);
    _controller = TextEditingController();
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
        backgroundColor: draw.backgroundcolor,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBarCustom(
                            title: '스페이스 리스트',
                            righticon: false,
                            iconname: Icons.add_box,
                          ),
                          GetBuilder<uisetting>(
                            builder: (_) => Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(
                                  child: ScrollConfiguration(
                                      behavior: NoBehavior(),
                                      child: SingleChildScrollView(
                                        physics: const ScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: GetBuilder<category>(
                                              builder: (_) => Pagination()),
                                        ),
                                      )),
                                )),
                          ),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  Pagination() {
    return GetBuilder<navibool>(
        builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '아래 스페이스 중 원하시는 스페이스를 선택하시면 됩니다.',
                  style: TextStyle(
                    fontSize: contentTextsize(),
                    color: draw.color_textstatus,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Page1(),
                const SizedBox(
                  height: 50,
                ),
                moveaction(),
                const SizedBox(
                  height: 50,
                )
              ],
            ));
  }

  moveaction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (cg.categorypicknumber == 99) {
                  Snack.show(
                      context: context,
                      title: '알림',
                      content: '스페이스 선택해주세요!',
                      snackType: SnackType.info,
                      behavior: SnackBarBehavior.floating);
                } else {
                  func6(context, _controller, searchNode, 'addtemplate',
                      widget.id, cg.categorypicknumber);
                }
              },
              child: ContainerDesign(
                  color: draw.backgroundcolor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '완료',
                        style: TextStyle(
                          fontSize: contentTextsize(),
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ))
      ],
    );
  }

  Page1() {
    List<String> listdata = [
      'URL, 파일, 사진 등을 담을 수 있는 스페이스',
      '일정정리를 도와주는 캘린더 스페이스',
      'Todo 리스트 스페이스',
      '메모 스페이스'
    ];
    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listdata.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<category>(
                      builder: (_) => GestureDetector(
                            onTap: () {
                              if (cg.categorypicknumber == index) {
                                cg.setcategorypicknumber(99);
                              } else {
                                cg.setcategorypicknumber(index);
                              }
                            },
                            child: ContainerDesign(
                                color: cg.categorypicknumber == index
                                    ? Colors.blue.shade200
                                    : draw.backgroundcolor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    cg.categorypicknumber == index
                                        ? const Icon(
                                            Icons.done_all,
                                            color: Colors.white,
                                            size: 25,
                                          )
                                        : Icon(
                                            Icons.ads_click,
                                            color: draw.color_textstatus,
                                            size: 25,
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        listdata[index],
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: draw.color_textstatus,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    )
                                  ],
                                )),
                          )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }))
      ],
    );
  }

  Page1_2() {
    return Column(
      children: [
        GetBuilder<category>(
            builder: (_) => FutureBuilder(
                future: firestore.collection('PageView').get().then((value) {
                  spaceindata.clear();
                  uiset.pageviewlist.clear();
                  if (value.docs.isEmpty) {
                  } else {
                    final valuespace = value.docs;
                    for (int i = 0; i < valuespace.length; i++) {
                      if (valuespace[i]['id'] == widget.id) {
                        if (cg.categorypicknumber == 0) {
                          for (int j = 0;
                              j < valuespace[i]['urllist'].length;
                              j++) {
                            spaceindata.add(valuespace[i]['urllist'][j]);
                          }
                          uiset.pageviewlist.add(PageviewList(
                              title: valuespace[i]['spacename'],
                              urlcontent: spaceindata,
                              type: valuespace[i]['type'],
                              uniquecode: valuespace[i]['id']));
                        } else if (cg.categorypicknumber == 1) {
                          uiset.pageviewlist.add(PageviewList(
                            title: valuespace[i]['spacename'],
                            type: valuespace[i]['type'],
                            uniquecode: valuespace[i]['id'],
                            calendarcontent:
                                valuespace[i]['calendarname'] ?? '',
                          ));
                        } else if (cg.categorypicknumber == 2) {
                          for (int j = 0;
                              j < valuespace[i]['todolist'].length;
                              j++) {
                            spaceindata.add(valuespace[i]['todolist'][j]);
                          }
                          uiset.pageviewlist.add(PageviewList(
                            title: valuespace[i]['spacename'],
                            type: valuespace[i]['type'],
                            uniquecode: valuespace[i]['id'],
                            todolistcontent: spaceindata,
                          ));
                        } else if (cg.categorypicknumber == 3) {
                          for (int j = 0;
                              j < valuespace[i]['memolist'].length;
                              j++) {
                            spaceindata.add(valuespace[i]['memolist'][j]);
                          }
                          uiset.pageviewlist.add(PageviewList(
                            title: valuespace[i]['spacename'],
                            type: valuespace[i]['type'],
                            uniquecode: valuespace[i]['id'],
                            memocontent: spaceindata,
                          ));
                        } else {}
                      }
                    }
                    uiset.pageviewlist.sort(((a, b) {
                      return a.title.compareTo(b.title);
                    }));
                  }
                }),
                builder: ((context, snapshot) {
                  if (uiset.pageviewlist.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 이 페이지에 있는 해당 스페이스 목록',
                          style: TextStyle(
                            fontSize: contentTextsize(),
                            color: TextColor_shadowcolor(),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            func6(
                                context,
                                _controller,
                                searchNode,
                                'addtemplate',
                                widget.id,
                                cg.categorypicknumber);
                          },
                          child: ContainerDesign(
                              color: BGColor(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      WidgetSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: mainTitleTextsize(),
                                            color: TextColor_shadowcolor()),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: TextColor_shadowcolor(),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '새 스페이스 추가',
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ContainerDesign(
                            color: BGColor(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                    // the number of items in the list
                                    itemCount: uiset.pageviewlist.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    // display each item of the product list
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          index == 1
                                              ? const Divider(
                                                  height: 10,
                                                  color: Colors.grey,
                                                  thickness: 0.5,
                                                  indent: 0,
                                                  endIndent: 0,
                                                )
                                              : const SizedBox(
                                                  height: 0,
                                                ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: RichText(
                                                text: TextSpan(children: [
                                              WidgetSpan(
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        mainTitleTextsize(),
                                                    color:
                                                        TextColor_shadowcolor()),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.ads_click,
                                                      color:
                                                          TextColor_shadowcolor(),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        uiset
                                                            .pageviewlist[index]
                                                            .title,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize:
                                                              contentTextsize(),
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        linkplacechangeoptions(
                                                            context,
                                                            index,
                                                            uiset
                                                                .pageviewlist[
                                                                    index]
                                                                .title,
                                                            uiset
                                                                .pageviewlist[
                                                                    index]
                                                                .uniquecode,
                                                            uiset
                                                                .pageviewlist[
                                                                    index]
                                                                .type,
                                                            _controller,
                                                            searchNode,
                                                            'pinchannel');
                                                      },
                                                      child: const Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.black45,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ])),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          index == 0
                                              ? const SizedBox(
                                                  height: 0,
                                                )
                                              : const Divider(
                                                  height: 10,
                                                  color: Colors.grey,
                                                  thickness: 0.5,
                                                  indent: 0,
                                                  endIndent: 0,
                                                ),
                                        ],
                                      );
                                    })
                              ],
                            )),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 이 페이지에 있는 해당 스페이스 목록',
                          style: TextStyle(
                            fontSize: contentTextsize(),
                            color: TextColor_shadowcolor(),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            func6(
                                context,
                                _controller,
                                searchNode,
                                'addtemplate',
                                widget.id,
                                cg.categorypicknumber);
                          },
                          child: ContainerDesign(
                              color: BGColor(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      WidgetSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: mainTitleTextsize(),
                                            color: TextColor_shadowcolor()),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: TextColor_shadowcolor(),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '새 스페이스 추가',
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ContainerDesign(
                            color: BGColor(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '불러오는 중입니다.',
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: contentTextsize(),
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 이 페이지에 있는 해당 스페이스 목록',
                          style: TextStyle(
                            fontSize: contentTextsize(),
                            color: TextColor_shadowcolor(),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            func6(
                                context,
                                _controller,
                                searchNode,
                                'addtemplate',
                                widget.id,
                                cg.categorypicknumber);
                          },
                          child: ContainerDesign(
                              color: BGColor(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      WidgetSpan(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: mainTitleTextsize(),
                                            color: TextColor_shadowcolor()),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: TextColor_shadowcolor(),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '새 스페이스 추가',
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ContainerDesign(
                            color: BGColor(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text(
                                        '비어있습니다.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ],
                    );
                  }
                })))
      ],
    );
  }

  Page2() {
    return Column(
      children: [],
    );
  }

  Page3() {
    return Column(
      children: [],
    );
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      draw.setnavi();
      if (uiset.searchpagemove != '') {
        Hive.box('user_setting').put('page_index', 11);
      } else {
        Hive.box('user_setting').put('page_index', 0);
      }

      Get.back();
    });
    return false;
  }
}
