import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../DB/AD_Home.dart';
import '../Sub/NoticePage.dart';

NoticeApps(BuildContext context, PageController pcontroll) {
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '0',
      title: '새로운 공지사항이 등록되었습니다.',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '1',
      title: '데이로그 관리 탭이 신설되었습니다.',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '챌린지 관리 탭이 신설되었습니다.',
      person_num: 4,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '페이지마크 관리 탭이 신설되었습니다.',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '개인키 관리 탭이 신설되었습니다.',
      person_num: 5,
      date: DateTime.now(),
    )
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            border: NeumorphicBorder.none(),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
            depth: -5,
            color: Colors.white,
          ),
          child: Column(
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
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                        },
                        child: NeumorphicIcon(
                          Icons.arrow_circle_right,
                          size: 20,
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 2,
                              color: Colors.deepPurpleAccent.shade100,
                              lightSource: LightSource.topLeft),
                        ),
                      ),
                    ],
                  )),
              NoticeClip(context, _list_ad, pcontroll),
            ],
          )),
    ],
  );
}

NoticeClip(context, List<AD_Home> list_ad, PageController pcontroll) {
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
