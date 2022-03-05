import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../DB/AD_Home.dart';

UserSubscription(BuildContext context, ScrollController mainController,
    ScrollController subController, bool isStickyOnTop,
    List<AD_Home> list_subscript) {
  return Column(
    children: [
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 15,
          ),
          child: Row(
            children: const [
              Icon(
                  Icons.subscriptions
              ),
              SizedBox(width: 10,),
              Text(
                'My 구독',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ],
          )
      ),
      Subscript(context, mainController, subController, list_subscript),
      //ContentSub(),
    ],
  );
}

ContentSub() {
  return Container(
    child: ListView.builder(
      //controller: mainController,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 35,
      itemBuilder: (context, index) =>
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                    decoration:
                    BoxDecoration(
                      border:
                      Border.all(
                        width: 1,
                        color: Colors.orangeAccent,
                      ),
                      borderRadius:
                      BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        '구독 명수 : ' +
                            index.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black45,
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
              )
            ],
          ),
    ),
  );
}
Subscript(context, ScrollController mainController,
    ScrollController subController, List<AD_Home> list_subscript) {
  return list_subscript.isEmpty
      ? Container(
    height: 0,
  ) : SizedBox(
    child: Column(
      children: [
        Sticky(context, mainController, subController, list_subscript),
      ],
    ),
  );
}
Sticky(context, ScrollController mainController, ScrollController subController,
    List<AD_Home> list_subscript) {
  return StickyHeader(
      header: Container(
        color: Colors.white,
        alignment: Alignment.topLeft,
        height: 70,
        child: ListView.builder(
          //controller: mainController,
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          scrollDirection: Axis.horizontal,
          itemCount: list_subscript.isEmpty
              ? 0
              : list_subscript.length,
          itemBuilder: (context, index) =>
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: Container(
                        decoration:
                        BoxDecoration(
                          border:
                          Border.all(
                            width: 1,
                            color: Colors.orangeAccent,
                          ),
                          borderRadius:
                          BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            list_subscript[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black45,
                            ),
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                  )
                ],
              ),
        ),
      ),
      content: ContentSub(),
  );
}