import 'package:carousel_slider/carousel_slider.dart';
import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/UI/Setting/BuyingPage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EventShowCard extends StatelessWidget {
  EventShowCard(
      {Key? key,
      required this.height,
      required this.pageController,
      required this.pageindex,
      required this.buy})
      : super(key: key);
  final double height;
  final int pageindex;
  final bool buy;
  final PageController pageController;
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List eventtitle = [];
  final List eventcontent = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width - 40,
        child: FutureBuilder(
            future: firestore
                .collection("EventNoticeDataBase")
                .where('eventpage',
                    isEqualTo: pageindex == 0 ? 'home' : 'analytic')
                .get()
                .then(((QuerySnapshot querySnapshot) => {
                      eventtitle.clear(),
                      eventcontent.clear(),
                      buy == true
                          ? querySnapshot.docs.forEach((doc) {
                              if (doc.get('eventname') != '버전 업그레이드 혜택') {
                                eventtitle.add(doc.get('eventname'));
                                eventcontent.add(doc.get('eventcontent'));
                              }
                            })
                          : querySnapshot.docs.forEach((doc) {
                              eventtitle.add(doc.get('eventname'));
                              eventcontent.add(doc.get('eventcontent'));
                            })
                    })),
            builder: (context, future) => future.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: const CircularProgressIndicator(),
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
                                    onTap: () {
                                      eventtitle[index] == '버전 업그레이드 혜택'
                                          ? Get.to(() => BuyingPage(),
                                              transition: Transition.fadeIn)
                                          : (eventtitle[index] == 'PDF 형식 지원'
                                              ? Get.to(() => BuyingPage(),
                                                  transition: Transition.fadeIn)
                                              : Get.to(() => BuyingPage(),
                                                  transition:
                                                      Transition.fadeIn));
                                    },
                                    child: Container(
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
                                    )),
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
