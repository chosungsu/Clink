import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import '../DB/PageList.dart';
import '../Tool/NoBehavior.dart';

class NoticePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final List<PageList> _list_ad = [
    PageList(
      id: '0',
      title: '데이로그 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '1',
      title: '챌린지 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '2',
      title: '페이지마크 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '3',
      title: '개인키 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Enternotice(),
    ));
  }
  Enternotice() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                        width: 50,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              child: NeumorphicIcon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: Colors.black45,
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60 - 160,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '공지사항',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              makeBody(context, _list_ad)
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }
}


// 바디 만들기
Widget makeBody(BuildContext context, List<PageList> list_ad) {
  return Neumorphic(
      style: const NeumorphicStyle(
        shape: NeumorphicShape.concave,
        color: Colors.white,
        depth: -1
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: ListView.separated(
                    //physics : 스크롤 막기 기능
                    //shrinkWrap : 리스트뷰 오버플로우 방지
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list_ad.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTile(
                        title: Text(
                          '${list_ad[index].title}',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Text(
                          '${list_ad[index].title}',
                          style: TextStyle(
                            height: 1.5,
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '작성일자 : ' + DateFormat('yyyy-MM-dd').parse('${list_ad[index].date}').toString().split(' ')[0],
                          style: TextStyle(
                            height: 1.5,
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        ],
                      );
                      /*Container(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            child: Text('${list_ad[index].title}'),
                            onTap: () {
                              if (index == 0) {
                              } else if (index == 1) {
                              } else if (index == 2) {
                              } else {}
                            },
                          ));*/
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ))
        ],
      ));
}
