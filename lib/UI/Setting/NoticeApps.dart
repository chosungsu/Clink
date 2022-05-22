import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../../DB/PageList.dart';
import '../../Sub/NoticePage.dart';
import '../../Tool/ContainerDesign.dart';

class NoticeApps extends StatelessWidget {
  NoticeApps({Key? key, required this.height, required this.pageController})
      : super(key: key);
  final double height;
  final PageController pageController;
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
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: ContainerDesign(
            child: SizedBox(
          height: height * 0.15,
          child: PageView.builder(
              scrollDirection: Axis.vertical,
              pageSnapping: false,
              itemCount: _list_ad.length,
              controller: pageController,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        _list_ad[index].title.toString(),
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
              }),
        )));
  }
}