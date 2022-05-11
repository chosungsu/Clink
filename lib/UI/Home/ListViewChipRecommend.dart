import 'package:clickbyme/Page/FeedPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';

import '../../DB/Contents.dart';
import '../../route.dart';

ListViewChipRecommend(
    BuildContext context, String string, List<Contents> list_content) {
  return Column(
    children: [
      SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    children: [
                      Flexible(
                          fit: FlexFit.tight,
                          child: Row(
                            children: [
                              NeumorphicText(
                                string,
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: Colors.black54,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const MyHomePage(
                                  title: 'StormDot',
                                  index: 1,
                                ),
                              ),
                            );
                            Hive.box('user_setting').put('page_index', 1);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200),
                            child: NeumorphicIcon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.deepPurpleAccent.shade100,
                                  lightSource: LightSource.topLeft),
                            ),
                          )),
                    ],
                  )),
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
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              border: NeumorphicBorder(
                                  width: 1, color: Colors.grey),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(5)),
                              depth: 5,
                              color: Colors.white,
                              //color: Colors.grey.shade200,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Container(
                                        color: Colors.amber,
                                      ))),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              list_content[index].title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.black45,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              list_content[index].content,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black45,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          )
                                        ],
                                      ))
                                ]),
                          ),
                        ),
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
}
