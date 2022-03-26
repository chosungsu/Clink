import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../DB/Contents.dart';

ListViewDayTimeLine(
    BuildContext context, String string, String str_snaps, String str_todo) {
  
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
                  itemCount: str_snaps.split(',').length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                border: NeumorphicBorder.none(),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(5)),
                                depth: 5,
                                color: Colors.white,
                              ),
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          str_todo.split(',')[index],
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
                                          str_snaps.split(',')[index].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      )
                                    ]),
                              )),
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
