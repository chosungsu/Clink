import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../DB/Contents.dart';
import '../DB/Home_Rec_title.dart';
import '../Tool/NoBehavior.dart';

ListViewFeed(
    BuildContext context, List<Home_Rec_title> list, List<Contents> list_content) {
  final List _list_background_color = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.orange,
  ];
  return CustomScrollView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      scrollBehavior: NoBehavior(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: NeumorphicText(
                              list[index].sub,
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: _list_background_color[index],
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView.builder(
                              //controller: mainController,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: list_content.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        child: Card(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    list_content[index].title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                    list_content[index]
                                                            .date
                                                            .year
                                                            .toString() +
                                                        '-' +
                                                        list_content[index]
                                                            .date
                                                            .month
                                                            .toString() +
                                                        '-' +
                                                        list_content[index]
                                                            .date
                                                            .day
                                                            .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                  )
                ],
              );
            },
            childCount: list.length,
          ),
        )
      ]);
}
