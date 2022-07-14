import 'package:carousel_slider/carousel_slider.dart';
import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/UI/Setting/SettingPage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transition/transition.dart';

class EventShowCard extends StatelessWidget {
  EventShowCard(
      {Key? key,
      required this.height,
      required this.pageController,
      required this.pageindex})
      : super(key: key);
  final double height;
  final int pageindex;
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
        height: 130,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: SettingPage()),
                  );
                },
                child: FutureBuilder(
                    future: firestore
                        .collection("EventNoticeDataBase")
                        .doc(pageindex == 0 ? '1' : '2')
                        .get()
                        .then((value) => {
                              eventtitle.clear(),
                              eventcontent.clear(),
                              eventtitle.add(value['eventname']),
                              eventcontent.add(value['eventcontent']),
                            }),
                    builder: (context, future) => future.connectionState ==
                            ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 100,
                                child: PageView.builder(
                                  itemCount: 1,
                                  controller: pageController,
                                  itemBuilder: (_, index) => Container(
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
                                                    NeumorphicIcon(
                                                      Icons.confirmation_number,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors.black45,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                        eventtitle[0]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80,
                                                height: 40,
                                                child: Text(
                                                    eventcontent[0].toString(),
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: SmoothPageIndicator(
                                      controller: pageController,
                                      count: 1,
                                      effect: ExpandingDotsEffect(
                                          dotHeight: 10,
                                          dotWidth: 10,
                                          dotColor: Colors.grey,
                                          activeDotColor: Colors.black),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ))
                //readdata(context, 0),
                )));
  }

  readdata(BuildContext context, int code) async {
    final eventsshowing =
        await firestore.collection("EventNoticeDataBase").doc("$code");
    eventsshowing.get().then((value) => {
          eventtitle.add(value['eventname']),
          eventcontent.add(value['eventcontent']),
        });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            itemCount: 1,
            controller: pageController,
            itemBuilder: (_, index) => Container(
                child: Column(
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: pageindex == 0
                        ? Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                height: 30,
                                child: Row(
                                  children: [
                                    NeumorphicIcon(
                                      Icons.confirmation_number,
                                      size: 25,
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(eventtitle[0].toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                height: 40,
                                child: Text(eventcontent[0].toString(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                height: 30,
                                child: Row(
                                  children: [
                                    NeumorphicIcon(
                                      Icons.confirmation_number,
                                      size: 25,
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(eventtitle[1].toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                height: 40,
                                child: Text(eventcontent[1].toString(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                            ],
                          )),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 1,
                effect: ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black),
              ),
            )
          ],
        )
      ],
    );
  }
}
