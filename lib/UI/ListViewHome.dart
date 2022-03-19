import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../DB/Contents.dart';
import '../DB/Recommend.dart';

ListViewHome(BuildContext context, List<Recommend> list) {
  final List<Contents> _list_content = [
    Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
    Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
    Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
    Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
    Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
  ];
  final List _list_background_color = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.orange,
  ];
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: list.length,
    itemBuilder: (context, index) => Column(
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
                    itemCount: _list_content.length,
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
                                          _list_content[index].title,
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
                                          _list_content[index]
                                                  .date
                                                  .year
                                                  .toString() +
                                              '-' +
                                              _list_content[index]
                                                  .date
                                                  .month
                                                  .toString() +
                                              '-' +
                                              _list_content[index]
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
    ),
  );
}
