import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../DB/Contents.dart';
import '../DB/Recommend.dart';

ListViewHome(BuildContext context, String string, List<Contents> list_content) {
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
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: Card(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        list_content[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                          fontWeight: FontWeight.bold,
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
}
