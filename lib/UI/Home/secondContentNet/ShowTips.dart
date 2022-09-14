import 'package:clickbyme/Sub/HowToUsePage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_redirect/store_redirect.dart';

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
  final List eventcontent = [];
  final List eventpage = [];

  @override
  Widget build(BuildContext context) {
    final newversion = NewVersion();
    final status = newversion.getVersionStatus();
    return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width - 40,
        child: FutureBuilder(
            future: firestore
                .collection("EventNoticeDataBase")
                .where('eventpage',
                    isEqualTo: pageindex == 0
                        ? 'home'
                        : (pageindex == 1 ? 'analytic' : 'ready'))
                .orderBy('number')
                .get()
                .then(((QuerySnapshot querySnapshot) => {
                      eventtitle.clear(),
                      eventcontent.clear(),
                      eventpage.clear(),
                      querySnapshot.docs.forEach((doc) {
                        eventtitle.add(doc.get('eventname'));
                        eventcontent.add(doc.get('eventcontent'));
                        if (pageindex == 1) {
                          eventpage.add(doc.get('url'));
                        }
                      })
                    })),
            builder: (context, future) => future.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ContainerDesign(
                    color: Colors.orange.shade400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120,
                          child: PageView.builder(
                              itemCount: eventtitle.length,
                              controller: pageController,
                              itemBuilder: (_, index) => GestureDetector(
                                    onTap: () async {
                                      //개별 인덱스 타이틀마다 이동페이지 다르게 구성
                                      eventtitle[index]
                                                  .toString()
                                                  .substring(0, 2) ==
                                              '일정'
                                          ? Get.to(
                                              () => const HowToUsePage(
                                                stringsend: '캘린더',
                                              ),
                                              transition: Transition.zoom,
                                            )
                                          : Get.to(
                                              () => const HowToUsePage(
                                                stringsend: '메모',
                                              ),
                                              transition: Transition.zoom,
                                            );
                                    },
                                    child: Column(
                                      children: [
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      80,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.orange
                                                                      .shade500,
                                                              child: const Icon(
                                                                Icons
                                                                    .card_giftcard,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                          eventtitle[index]
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      80,
                                                  height: 60,
                                                  child: Text(
                                                      eventcontent[index]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                ),
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: eventtitle.length,
                                effect: const ExpandingDotsEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    dotColor: Colors.grey,
                                    activeDotColor: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ))));
  }
}

class EventApps extends StatelessWidget {
  EventApps({
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
  final List eventcontent = [];
  final List eventpage = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firestore
            .collection("EventNoticeDataBase")
            .where('eventpage', isEqualTo: 'analytic')
            .orderBy('number')
            .get()
            .then(((QuerySnapshot querySnapshot) => {
                  eventtitle.clear(),
                  eventcontent.clear(),
                  eventpage.clear(),
                  querySnapshot.docs.forEach((doc) {
                    eventtitle.add(doc.get('eventname'));
                    eventcontent.add(doc.get('eventcontent'));
                    eventpage.add(doc.get('url'));
                  })
                })),
        builder: (context, future) => future.connectionState ==
                ConnectionState.waiting
            ? const SizedBox(
                height: 110,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (eventcontent.isEmpty
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContainerDesign(
                          color: Colors.grey.shade400,
                          child: SizedBox(
                            height: 70,
                            child: PageView.builder(
                                itemCount: eventtitle.length,
                                controller: pageController,
                                itemBuilder: (_, index) => GestureDetector(
                                      onTap: () {
                                        if (eventtitle[index] ==
                                            'New version 출시') {
                                          StoreRedirect.redirect(
                                            androidAppId:
                                                'com.jss.habittracker', // Android app bundle package name
                                          );
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange
                                                                        .shade500,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .card_giftcard,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          eventtitle[index]
                                                              .toString(),
                                                          maxLines: 1,
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
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    child: Text(
                                                      eventcontent[index]
                                                          .toString(),
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    )),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )));
  }
}