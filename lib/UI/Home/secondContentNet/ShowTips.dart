import 'package:clickbyme/Sub/HowToUsePage.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/providers/mongodatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Tool/TextSize.dart';

class ShowTips extends StatelessWidget {
  ShowTips({
    Key? key,
    required this.height,
    required this.pageController,
    required this.pageindex,
  }) : super(key: key);
  final double height;
  final int pageindex;
  final PageController pageController;
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List eventtitle = [];
  final List eventurl = [];
  final List eventcontent = [];
  final List eventsmalltitles = [];
  final List eventsmallcontent = [];
  final List eventpage = [];
  List<Map> eventtotalmap = [];
  Map eventtotal = {};

  @override
  Widget build(BuildContext context) {
    final newversion = NewVersion();
    final status = newversion.getVersionStatus();
    bool serverstatus = Hive.box('user_info').get('server_status');

    return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: serverstatus == true
            ? FutureBuilder(
                future:
                    MongoDB.getData(collectionname: 'howtouse').then(((value) {
                  eventtitle.clear();
                  eventurl.clear();
                  for (int i = 0; i < value.length; i++) {
                    final where = value[i]['where'];
                    if (where == 'home') {
                      eventtitle.add(value[i]['what']);
                      eventurl.add(Uri.parse(value[i]['url']));
                    }
                  }
                })),
                builder: (context, future) => future.connectionState ==
                        ConnectionState.waiting
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '사용법 페이지 불러오는중...',
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
                        ],
                      )
                    : SizedBox(
                        height: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: eventtitle.length,
                                    itemBuilder: ((context, index) {
                                      return Row(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.amber,
                                              ),
                                              child: SizedBox(
                                                height: 150,
                                                width: 130,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (await canLaunchUrl(
                                                        eventurl[index])) {
                                                      launchUrl(
                                                          eventurl[index]);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  const CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: Icon(
                                                                  Icons
                                                                      .bubble_chart,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          eventtitle[index]
                                                              .toString(),
                                                          maxLines: 3,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    }))),
                          ],
                        ),
                      ))
            : FutureBuilder(
                future: firestore
                    .collection("EventNoticeDataBase")
                    .where('eventpage', isEqualTo: 'home')
                    .get()
                    .then(((QuerySnapshot querySnapshot) => {
                          eventtitle.clear(),
                          querySnapshot.docs.forEach((doc) {
                            eventtitle.add(doc.get('eventname'));
                            eventurl.add(Uri.parse(doc.get('url')));
                          }),
                        })),
                builder: (context, future) => future.connectionState ==
                        ConnectionState.waiting
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '사용법 페이지 불러오는중...',
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
                        ],
                      )
                    : SizedBox(
                        height: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: eventtitle.length,
                                    itemBuilder: ((context, index) {
                                      return Row(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.amber,
                                              ),
                                              child: SizedBox(
                                                height: 150,
                                                width: 130,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (await canLaunchUrl(
                                                        eventurl[index])) {
                                                      launchUrl(
                                                          eventurl[index]);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  const CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: Icon(
                                                                  Icons
                                                                      .bubble_chart,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          eventtitle[index]
                                                              .toString(),
                                                          maxLines: 3,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    }))),
                          ],
                        ),
                      )));
  }
}
