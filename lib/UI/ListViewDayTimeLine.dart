import 'package:clickbyme/DB/TODO.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../DB/Contents.dart';

ListViewDayTimeLine(
    BuildContext context, String string, List<TODO> str_todo_list) {
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
              str_todo_list.length > 0
                  ? Expanded(
                      child: ListView.builder(
                        //controller: mainController,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: str_todo_list.length,
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
                                      depth: -5,
                                      color: Colors.white,
                                      //color: Colors.grey.shade200,
                                    ),
                                    child: Card(
                                      color: Colors.white,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                flex: 2,
                                                child: Center(
                                                  child: Text(
                                                    str_todo_list[index].title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black45,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                            Flexible(
                                              flex: 1,
                                              child: Text(
                                                '시간 : ' +
                                                    str_todo_list[index].time +
                                                    (int.parse(str_todo_list[
                                                                    index]
                                                                .time
                                                                .split(
                                                                    ':')[0]) >=
                                                            12
                                                        ? 'PM'
                                                        : 'AM'),
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
                  : Expanded(
                      child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              border: NeumorphicBorder.none(),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(5)),
                              depth: -5,
                              color: Colors.white,
                              //color: Colors.grey.shade200,
                            ),
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '오늘의 일정은 작성된 것이 없습니다.',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ]),
                            )),
                      ),
                    ))
            ],
          )),
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
      )
    ],
  );
}
