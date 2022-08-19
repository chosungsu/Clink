import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/SheetGetx/memosearchsetting.dart';
import 'package:clickbyme/Tool/SheetGetx/memosortsetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/ClickShowEachNote.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/settingMemoHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Page/HomePage.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/selectcollection.dart';
import '../../../sheets/addPayStory.dart';
import '../../../sheets/addWhole.dart';
import '../secondContentNet/EventShowCard.dart';

class PayHome extends StatefulWidget {
  const PayHome({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PayHomeState();
}

class _PayHomeState extends State<PayHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  int sortmemo_fromsheet = 0;
  int searchmemo_fromsheet = 0;
  final controll_memo = Get.put(memosearchsetting());
  final controll_memo2 = Get.put(memosortsetting());
  final scollection = Get.put(selectcollection());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final searchNode = FocusNode();
  String username = Hive.box('user_info').get(
    'id',
  );
  int sort = 0;
  List<String> textsummary = [];
  String tmpsummary = '';
  DateTime Date = DateTime.now();
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    searchmemo_fromsheet = controll_memo.memosearch;
    sortmemo_fromsheet = controll_memo2.memosort;
    controller = TextEditingController();
    sort = Hive.box('user_setting').get('sort_cal_card') ?? 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Future<bool> _onWillPop() async {
    Get.back(result: true);
    return true;
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
          decoration: BoxDecoration(color: BGColor()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Get.back(result: true);
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.keyboard_arrow_left,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text('PayStory',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 25,
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      addPaystory(
                                                          context,
                                                          searchNode,
                                                          controller,
                                                          username,
                                                          Date,
                                                          'cal');
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.add,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ))),
                                          ],
                                        ))),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              DutchPayShow(),
                              const SizedBox(
                                height: 20,
                              ),
                              ADBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              DutchList(),
                              const SizedBox(
                                height: 20,
                              ),
                              ReceiptList(),
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

  DutchPayShow() {
    return SizedBox(
        height: 210,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('최근 작성된 폼을 보여드려요!',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 150,
              child: ContainerDesign(
                  child: SizedBox(
                    child: Row(
                      children: [],
                    ),
                  ),
                  color: BGColor()),
            )
          ],
        ));
  }

  ADBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ADEvents(context),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  DutchList() {
    return ContainerDesign(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('더치페이',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
                InkWell(
                  onTap: () {
                    addPaystory(
                        context, searchNode, controller, username, Date, 'cal');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: NeumorphicIcon(
                      Icons.navigate_next,
                      size: 25,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: NeumorphicIcon(
                    Icons.info,
                    size: 25,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.blue,
                        lightSource: LightSource.topLeft),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('이 곳에는 최신 리스트 5개만 보여집니다.',
                    style: TextStyle(
                        color: TextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(builder: (_, StateSetter setState) {
              return StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('DutchPayDataBase')
                    .where('name', isEqualTo: username)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.docs.length);
                    return snapshot.data!.docs.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '작성된 더치페이 리스트가 아직 없습니다.',
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: TextColor(),
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: contentTextsize(),
                                  ),
                                ),
                              )
                            ],
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: ListTile(
                                      onTap: () {},
                                      horizontalTitleGap: 10,
                                      dense: true,
                                      leading: const Icon(Icons.table_view),
                                      title: Text(
                                          snapshot.data!.docs[index]['date'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize())),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '작성된 더치페이 리스트가 아직 없습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: contentTextsize(),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            })
          ],
        ),
        color: BGColor());
  }

  ReceiptList() {
    return ContainerDesign(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('전자영수증',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
                InkWell(
                  onTap: () {
                    addPaystory(
                        context, searchNode, controller, username, Date, 'cal');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: NeumorphicIcon(
                      Icons.navigate_next,
                      size: 25,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: NeumorphicIcon(
                    Icons.info,
                    size: 25,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.blue,
                        lightSource: LightSource.topLeft),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('이 곳에는 최신 리스트 5개만 보여집니다.',
                    style: TextStyle(
                        color: TextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(builder: (_, StateSetter setState) {
              return StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('ReceiptDataBase')
                    .where('name', isEqualTo: username)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.docs.length);
                    return snapshot.data!.docs.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '작성된 영수증 리스트가 아직 없습니다.',
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: TextColor(),
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: contentTextsize(),
                                  ),
                                ),
                              )
                            ],
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: ListTile(
                                      onTap: () {},
                                      horizontalTitleGap: 10,
                                      dense: true,
                                      leading: const Icon(Icons.table_view),
                                      title: Text(
                                          snapshot.data!.docs[index]['date'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize())),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '작성된 영수증 리스트가 아직 없습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: contentTextsize(),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            })
          ],
        ),
        color: BGColor());
  }
}
