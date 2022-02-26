import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('피드', style: TextStyle(color: Colors.blueGrey)),
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
        child: Container(
          child: Center(
            child: makeBody(context),
          ),
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
            child: new Text('아니요'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('네'),
          ),
        ],
      ),
    )) ?? false;
  }


}
//바텀시트 클래스(1 : 추가버튼 클릭시 뜨는 내용)
_onAddPressed(BuildContext context) {
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

// 바디 만들기
Widget makeBody(BuildContext context) {

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child : Center(
                child : Column(
                    children : <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
                        //child: LoginBtn(),
                        child: Column(
                          children: [

                          ],
                        ),
                      ),
                    ]
                )
            )
        ),
      ],
    ),

  );
}