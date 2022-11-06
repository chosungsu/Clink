import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../../DB/Linkpage.dart';
import '../../../Route/subuiroute.dart';
import '../../../Tool/AppBarCustom.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../../../mongoDB/mongodatabase.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.where, required this.link})
      : super(key: key);
  final String where;
  final String link;

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  String usercode = Hive.box('user_setting').get('usercode');
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];
  final peopleadd = Get.put(PeopleAdd());
  final linkspaceset = Get.put(linkspacesetting());
  final List<Linksapcepage> listspacepageset = [];
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    widget.where == 'home'
        ? Future.delayed(const Duration(seconds: 0), () {
            GoToMain(context);
          })
        : Future.delayed(const Duration(seconds: 0), () {
            StatusBarControl.setColor(linkspaceset.color, animated: true);
            Get.back();
          });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: WillPopScope(
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
              const AppBarCustom(
                title: '',
                righticon: true,
                iconname: Icons.close,
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
                              const SizedBox(
                                height: 20,
                              ),
                              BuildTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              BuildContent(),
                              const SizedBox(
                                height: 50,
                              ),
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

  BuildTitle() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
          widget.where == 'home'
              ? '이곳에서 홈뷰의 순서를 변경하거나 숨길수 있어요'
              : '이곳에서 뷰의 순서를 변경할 수 있어요',
          maxLines: 3,
          style: TextStyle(
            fontSize: secondTitleTextsize(),
            color: TextColor(),
            fontWeight: FontWeight.bold,
          )),
    );
  }

  BuildContent() {
    var user, linkname;
    return widget.where == 'home'
        ? GetBuilder<PeopleAdd>(
            builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('현재 홈뷰',
                        style: TextStyle(
                            color: TextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                    peopleadd.defaulthomeviewlist.isNotEmpty
                        ? GetBuilder<PeopleAdd>(
                            builder: ((controller) =>
                                ReorderableListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      peopleadd.defaulthomeviewlist.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      key: ValueKey(index),
                                      height: 80,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: ListTile(
                                              onTap: () {},
                                              horizontalTitleGap: 10,
                                              dense: true,
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.drag_indicator,
                                                    color: TextColor(),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (peopleadd
                                                                .defaulthomeviewlist
                                                                .length >
                                                            2) {
                                                          peopleadd.userviewlist
                                                              .add(peopleadd
                                                                      .defaulthomeviewlist[
                                                                  index]);
                                                          peopleadd
                                                              .defaulthomeviewlist
                                                              .removeAt(index);
                                                          if (serverstatus) {
                                                            MongoDB.update(
                                                                collectionname:
                                                                    'homeview',
                                                                query:
                                                                    'usercode',
                                                                what: Hive.box(
                                                                        'user_setting')
                                                                    .get(
                                                                        'usercode'),
                                                                updatelist: {
                                                                  'viewcategory':
                                                                      peopleadd
                                                                          .defaulthomeviewlist,
                                                                  'hidecategory':
                                                                      peopleadd
                                                                          .userviewlist
                                                                });
                                                            firestore
                                                                .collection(
                                                                    'HomeViewCategories')
                                                                .doc(Hive.box(
                                                                        'user_setting')
                                                                    .get(
                                                                        'usercode'))
                                                                .update({
                                                              'viewcategory':
                                                                  peopleadd
                                                                      .defaulthomeviewlist,
                                                              'hidecategory':
                                                                  peopleadd
                                                                      .userviewlist
                                                            });
                                                          } else {
                                                            firestore
                                                                .collection(
                                                                    'HomeViewCategories')
                                                                .doc(Hive.box(
                                                                        'user_setting')
                                                                    .get(
                                                                        'usercode'))
                                                                .update({
                                                              'viewcategory':
                                                                  peopleadd
                                                                      .defaulthomeviewlist,
                                                              'hidecategory':
                                                                  peopleadd
                                                                      .userviewlist
                                                            });
                                                          }
                                                        } else {
                                                          Snack.show(
                                                              title: '알림',
                                                              content:
                                                                  '홈뷰는 2개 미만으로 설정 불가합니다.',
                                                              snackType:
                                                                  SnackType
                                                                      .warning,
                                                              context: context);
                                                        }
                                                      });
                                                    },
                                                    child: Text('숨김',
                                                        style: TextStyle(
                                                            color: peopleadd
                                                                        .defaulthomeviewlist
                                                                        .length >
                                                                    2
                                                                ? TextColor()
                                                                : TextColor_shadowcolor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                  ),
                                                ],
                                              ),
                                              leading: SizedBox(
                                                height: 60,
                                                width: 60,
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: 40,
                                                    width: 40,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue.shade200,
                                                      child: Icon(
                                                        peopleadd.defaulthomeviewlist[index].toString().substring(
                                                                    peopleadd
                                                                            .defaulthomeviewlist[
                                                                                index]
                                                                            .toString()
                                                                            .length -
                                                                        2,
                                                                    peopleadd
                                                                        .defaulthomeviewlist[
                                                                            index]
                                                                        .toString()
                                                                        .length) ==
                                                                '일정'
                                                            ? Icons
                                                                .calendar_month
                                                            : Icons.description,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ),
                                              title: GetBuilder<PeopleAdd>(
                                                builder: (controller) => Text(
                                                    peopleadd
                                                        .defaulthomeviewlist[
                                                            index]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize())),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onReorder: (int oldIndex, int newIndex) {
                                    setState(() {
                                      if (oldIndex < newIndex) {
                                        newIndex -= 1;
                                      }
                                      final element = peopleadd
                                          .defaulthomeviewlist
                                          .removeAt(oldIndex);
                                      peopleadd.defaulthomeviewlist
                                          .insert(newIndex, element);
                                    });
                                    if (serverstatus) {
                                      MongoDB.update(
                                        collectionname: 'homeview',
                                        query: 'usercode',
                                        what: Hive.box('user_setting')
                                            .get('usercode'),
                                        updatelist: {
                                          'viewcategory':
                                              peopleadd.defaulthomeviewlist,
                                        },
                                      );
                                      firestore
                                          .collection('HomeViewCategories')
                                          .doc(Hive.box('user_setting')
                                              .get('usercode'))
                                          .update(
                                        {
                                          'viewcategory':
                                              peopleadd.defaulthomeviewlist,
                                        },
                                      );
                                    } else {
                                      firestore
                                          .collection('HomeViewCategories')
                                          .doc(Hive.box('user_setting')
                                              .get('usercode'))
                                          .update(
                                        {
                                          'viewcategory':
                                              peopleadd.defaulthomeviewlist,
                                        },
                                      );
                                    }
                                    peopleadd.setcategory();
                                  },
                                  proxyDecorator: (Widget child, int index,
                                      Animation<double> animation) {
                                    return Material(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: TextColor_shadowcolor(),
                                                width: 1)),
                                        child: child,
                                      ),
                                    );
                                  },
                                )))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  ContainerDesign(
                                      child: ListTile(
                                        onTap: () {},
                                        horizontalTitleGap: 10,
                                        dense: true,
                                        title: Text(
                                            '보기를 클릭시 홈뷰에 나타나게 할 수 있습니다.',
                                            style: TextStyle(
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize())),
                                      ),
                                      color: Colors.grey.shade300),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            }),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('숨긴 뷰',
                        style: TextStyle(
                            color: TextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                    peopleadd.userviewlist.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: peopleadd.userviewlist.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: ListTile(
                                      onTap: () {},
                                      horizontalTitleGap: 10,
                                      dense: true,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                peopleadd.defaulthomeviewlist
                                                    .add(peopleadd
                                                        .userviewlist[index]);
                                                peopleadd.userviewlist
                                                    .removeAt(index);
                                                if (serverstatus) {
                                                  MongoDB.update(
                                                      collectionname:
                                                          'homeview',
                                                      query: 'usercode',
                                                      what: Hive.box(
                                                              'user_setting')
                                                          .get('usercode'),
                                                      updatelist: {
                                                        'viewcategory': peopleadd
                                                            .defaulthomeviewlist,
                                                        'hidecategory':
                                                            peopleadd
                                                                .userviewlist
                                                      });
                                                  firestore
                                                      .collection(
                                                          'HomeViewCategories')
                                                      .doc(Hive.box(
                                                              'user_setting')
                                                          .get('usercode'))
                                                      .update({
                                                    'viewcategory': peopleadd
                                                        .defaulthomeviewlist,
                                                    'hidecategory':
                                                        peopleadd.userviewlist
                                                  });
                                                } else {
                                                  firestore
                                                      .collection(
                                                          'HomeViewCategories')
                                                      .doc(Hive.box(
                                                              'user_setting')
                                                          .get('usercode'))
                                                      .update({
                                                    'viewcategory': peopleadd
                                                        .defaulthomeviewlist,
                                                    'hidecategory':
                                                        peopleadd.userviewlist
                                                  });
                                                }
                                              });
                                            },
                                            child: Text('보기',
                                                style: TextStyle(
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize())),
                                          ),
                                        ],
                                      ),
                                      leading: SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            width: 40,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.blue.shade200,
                                              child: Icon(
                                                peopleadd.userviewlist[index]
                                                            .toString()
                                                            .substring(
                                                                peopleadd
                                                                        .userviewlist[
                                                                            index]
                                                                        .toString()
                                                                        .length -
                                                                    2,
                                                                peopleadd
                                                                    .userviewlist[
                                                                        index]
                                                                    .toString()
                                                                    .length) ==
                                                        '일정'
                                                    ? Icons.calendar_month
                                                    : Icons.description,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                      title: Text(
                                          peopleadd.userviewlist[index]
                                              .toString(),
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize())),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            })
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  ContainerDesign(
                                      child: ListTile(
                                        onTap: () {},
                                        horizontalTitleGap: 10,
                                        dense: true,
                                        title: Text('숨김을 클릭시 이곳에 뷰를 숨길 수 있습니다.',
                                            style: TextStyle(
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize())),
                                      ),
                                      color: Colors.grey.shade300),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            })
                  ],
                ))
        : FutureBuilder(
            future:
                MongoDB.getData(collectionname: 'pinchannelin').then((value) {
              linkspaceset.indexcnt.clear();
              if (value.isEmpty) {
              } else {
                for (var sp in value) {
                  user = sp['username'];
                  linkname = sp['linkname'];
                  if (usercode == user && widget.link == linkname) {
                    linkspaceset.indexcnt.add(Linksapcepage(
                        index: int.parse(sp['index'].toString()),
                        placestr: sp['placestr']));
                  }
                }
                linkspaceset.indexcnt.sort(((a, b) {
                  return a.index.compareTo(b.index);
                }));
              }
            }),
            builder: (context, snapshot) {
              return linkspaceset.indexcnt.isEmpty
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
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ReorderableListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: linkspaceset.indexcnt.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              key: ValueKey(index),
                              height: 80,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: ListTile(
                                      onTap: () {},
                                      horizontalTitleGap: 10,
                                      dense: true,
                                      trailing: Icon(
                                        Icons.drag_indicator,
                                        color: TextColor(),
                                      ),
                                      title: GetBuilder<linkspacesetting>(
                                        builder: (controller) => Text(
                                            linkspaceset
                                                .indexcnt[index].placestr
                                                .toString(),
                                            style: TextStyle(
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize())),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            );
                          },
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item =
                                  linkspaceset.indexcnt.removeAt(oldIndex);
                              linkspaceset.indexcnt.insert(newIndex, item);
                            });
                            /*if (serverstatus) {
                                      MongoDB.update(
                                        collectionname: 'homeview',
                                        query: 'usercode',
                                        what: Hive.box('user_setting')
                                            .get('usercode'),
                                        updatelist: {
                                          'viewcategory':
                                              peopleadd.defaulthomeviewlist,
                                        },
                                      );
                                      firestore
                                          .collection('HomeViewCategories')
                                          .doc(Hive.box('user_setting')
                                              .get('usercode'))
                                          .update(
                                        {
                                          'viewcategory':
                                              peopleadd.defaulthomeviewlist,
                                        },
                                      );
                                    } else {
                                      firestore
                                          .collection('HomeViewCategories')
                                          .doc(Hive.box('user_setting')
                                              .get('usercode'))
                                          .update(
                                        {
                                          'viewcategory':
                                              peopleadd.defaulthomeviewlist,
                                        },
                                      );
                                    }*/
                          },
                          proxyDecorator: (Widget child, int index,
                              Animation<double> animation) {
                            return Material(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: TextColor_shadowcolor(),
                                        width: 1)),
                                child: child,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
            },
          );
  }
}
