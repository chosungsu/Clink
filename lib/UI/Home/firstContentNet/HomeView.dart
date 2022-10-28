import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../Tool/BGColor.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../../../providers/mongodatabase.dart';
import '../../Sign/UserCheck.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];
  final peopleadd = Get.put(PeopleAdd());
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
    Future.delayed(const Duration(seconds: 0), () {
      GoToMain(context);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
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
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize(),
                                        color: TextColor()),
                                  ),
                                ),
                                IconBtn(
                                    child: IconButton(
                                        onPressed: () {
                                          Future.delayed(
                                              const Duration(seconds: 0), () {
                                            GoToMain(context);
                                          });
                                        },
                                        icon: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.close,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        )),
                                    color: TextColor())
                              ],
                            )),
                      ],
                    ),
                  )),
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
      child: Text('이곳에서 홈뷰의 순서를 변경하거나 숨길수 있어요',
          maxLines: 3,
          style: TextStyle(
            fontSize: secondTitleTextsize(),
            color: TextColor(),
            fontWeight: FontWeight.bold,
          )),
    );
  }

  BuildContent() {
    return GetBuilder<PeopleAdd>(
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
                        builder: ((controller) => ReorderableListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: peopleadd.defaulthomeviewlist.length,
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
                                                            query: 'usercode',
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
                                                          'viewcategory': peopleadd
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
                                                          'viewcategory': peopleadd
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
                                                              SnackType.warning,
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
                                                        ? Icons.calendar_month
                                                        : Icons.description,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                          title: GetBuilder<PeopleAdd>(
                                            builder: (controller) => Text(
                                                peopleadd
                                                    .defaulthomeviewlist[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
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
                                  final element = peopleadd.defaulthomeviewlist
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
                                    title: Text('보기를 클릭시 홈뷰에 나타나게 할 수 있습니다.',
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
                                            peopleadd.defaulthomeviewlist.add(
                                                peopleadd.userviewlist[index]);
                                            peopleadd.userviewlist
                                                .removeAt(index);
                                            if (serverstatus) {
                                              MongoDB.update(
                                                  collectionname: 'homeview',
                                                  query: 'usercode',
                                                  what: Hive.box('user_setting')
                                                      .get('usercode'),
                                                  updatelist: {
                                                    'viewcategory': peopleadd
                                                        .defaulthomeviewlist,
                                                    'hidecategory':
                                                        peopleadd.userviewlist
                                                  });
                                              firestore
                                                  .collection(
                                                      'HomeViewCategories')
                                                  .doc(Hive.box('user_setting')
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
                                                  .doc(Hive.box('user_setting')
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
                                                fontSize: contentTextsize())),
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
                                          backgroundColor: Colors.blue.shade200,
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
                                      peopleadd.userviewlist[index].toString(),
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
            ));
  }
}
