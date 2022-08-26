import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../Tool/Getx/memosearchsetting.dart';
import '../Tool/Getx/memosortsetting.dart';

SheetPage_memo(
  BuildContext context,
  int sortmemo_fromsheet,
  memosearchsetting controll_memo,
  memosortsetting controll_memo2,
  int searchmemo_fromsheet,
) {
  return SizedBox(
      height: 300,
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(context, sortmemo_fromsheet, controll_memo,
                  controll_memo2, searchmemo_fromsheet)
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

content(
  BuildContext context,
  int sortmemo_fromsheet,
  memosearchsetting controll_memo,
  memosortsetting controll_memo2,
  int searchmemo_fromsheet,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: Text('검색 조건설정',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize())),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                primary: searchmemo_fromsheet == 0
                                    ? Colors.grey.shade400
                                    : Colors.white,
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black45,
                                )),
                            onPressed: () {
                              setState(() {
                                controll_memo.setmemo1();
                                searchmemo_fromsheet = controll_memo.memosearch;
                              });
                            },
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: NeumorphicText(
                                      '제목',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: searchmemo_fromsheet == 0
                                            ? Colors.white
                                            : Colors.black45,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              primary: searchmemo_fromsheet == 1
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              controll_memo.setmemo2();
                              searchmemo_fromsheet = controll_memo.memosearch;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '내용',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: searchmemo_fromsheet == 1
                                          ? Colors.white
                                          : Colors.black45,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              primary: searchmemo_fromsheet == 2
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              controll_memo.setmemo3();
                              searchmemo_fromsheet = controll_memo.memosearch;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '중요도',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: searchmemo_fromsheet == 2
                                          ? Colors.white
                                          : Colors.black45,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: Text('정렬기준',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize())),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                primary: sortmemo_fromsheet == 0
                                    ? Colors.grey.shade400
                                    : Colors.white,
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black45,
                                )),
                            onPressed: () {
                              setState(() {
                                controll_memo2.sort1();
                                sortmemo_fromsheet = controll_memo2.memosort;
                              });
                            },
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: NeumorphicText(
                                      '컬렉션순',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: sortmemo_fromsheet == 0
                                            ? Colors.white
                                            : Colors.black45,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              primary: sortmemo_fromsheet == 1
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              controll_memo2.sort2();
                              sortmemo_fromsheet = controll_memo2.memosort;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '중요도순',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: sortmemo_fromsheet == 1
                                          ? Colors.white
                                          : Colors.black45,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  });
}
