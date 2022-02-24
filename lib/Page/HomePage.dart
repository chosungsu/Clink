import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../DB/Subscription_db.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final List<Subscription_db> _list_sub = [
    Subscription_db(
      id: '1',
      title: 'Netflix',
      person_num: 3,
      date: DateTime.now(),
    ),
    Subscription_db(
      id: '2',
      title: 'Coupang Play',
      person_num: 4,
      date: DateTime.now(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Aindrop', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () =>
            {
              //bottomsheet 사용하기
              _onAddPressed(context),
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: const Text(
                '마이 구독',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 5, horizontal: 15,
              ),
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                  BorderRadius.circular(16.0),
              ),
              elevation: 4.0,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Column(
                    children: _list_sub.map((e) {
                      return Card(
                        shape: ContinuousRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                            side: const BorderSide(width: 0.5)
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                e.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(e.date),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '현재 참여중인 인원 수 : ' +
                                            e.person_num.toString() + '명',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5,
                                      ),
                                    ),
                                  ],

                                ),

                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            )

          ],
        ),
      ),

    );
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('아니요'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('네'),
          ),
        ],
      ),
    )) ?? false;
  }
}
//바텀시트 클래스(1 : add버튼 클릭시 뜨는 내용)
_onAddPressed(context) {
  showModalBottomSheet(context: context, builder: (BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.add_link_rounded),
            title: const Text('관심태그 추가'),
            onTap: () => {

            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('업로드'),
            onTap: () => {
              //이전 바텀시트 제거 후 스택 새로 쌓기
              Navigator.pop(context),
              _onUploadPressed(context),
            },
          ),
        ],
      ),
    );
  });
}
//바텀시트 클래스(2 : 업로드버튼 클릭시 뜨는 내용)
_onUploadPressed(context) {
  showModalBottomSheet(
      //max로 스크롤 가능하게함.
      isScrollControlled : true,
      context: context,
      builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
          ),
          child : Container(
            padding: EdgeInsets.only(bottom: MediaQuery
                .of(context).viewInsets.bottom),
            child: Column(
              //내부를 최소만큼 키움.
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: const Text(
                        '공유할 피드 작성',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5,
                      ),
                    ),
                  ],
                ),
                Flexible(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: '제목(Title)'
                        ),
                      ),
                    )
                ),
                Flexible(
                    child: Container(
                      height: 400,
                      margin: const EdgeInsets.all(10),
                      child: const TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: '본문(Text)',
                        ),
                      ),
                    )
                ),
                Flexible(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: '태그(Tags)'
                        ),
                      ),
                    )
                ),
                OutlinedButton(
                  child: const Text("작성완료"),
                  onPressed: () {
                    //게시글 작성완료 버튼
                  },
                )
              ],
            ),
          )
      ),
    );
  });
}
