import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../../DB/PageList.dart';
import '../../Sub/NoticePage.dart';

NoticeApps(BuildContext context, PageController pcontroll) {
  final List<PageList> _list_ad = [
    PageList(
      id: '0',
      title: '새로운 공지사항이 등록되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '1',
      title: '데이로그 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '2',
      title: '챌린지 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '3',
      title: '페이지마크 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '4',
      title: '탐색기록 관리 탭이 신설되었습니다.',
      date: DateTime.now(),
    )
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: Row(
                children: [
                  const Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      '공지사항',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: NoticePage(),
                                type: PageTransitionType.leftToRightWithFade));
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
          NoticeClip(context, _list_ad, pcontroll),
        ],
      )
    ],
  );
}

NoticeClip(context, List<PageList> list_ad, PageController pcontroll) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: Colors.orange, width: 1)),
          elevation: 4.0,
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  pageSnapping: false,
                  itemCount: list_ad.length,
                  controller: pcontroll,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            list_ad[index].title.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'today',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color.fromARGB(115, 175, 175, 175),
                            ),
                          ),
                        ),
                      ],
                    );
                  }))),
    ),
  );
}
