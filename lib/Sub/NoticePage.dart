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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text('공지사항', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: makeBody(context, _list_ad),
              ))),
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
