import 'package:flutter/material.dart';
import '../UI/NoBehavior.dart';


class WritePost extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  //appbar에 변화주기
  final _scrollController = ScrollController();
  double scrollOpacity = 0;
  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(onScroll);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.removeListener(onScroll);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.orangeAccent,
          iconSize: 18,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              checkwhoshow(),
            },
            child: const Text(
              "공유대상",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.send),
            iconSize: 18,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: makeBody(context),
        ),
      ),
    );
  }
  onScroll() {
    setState(() {
      double offset = _scrollController.offset;
      if (offset < 0) {
        offset = 0;
      } else if (offset > 100) {
        offset = 100;
      }
      scrollOpacity = offset / 100;
    });
  }

  checkwhoshow() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Text(
              "공개범위 설정",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Text(
                "공개범위 설정 기본값 변경은 "
                "부가설정 > 기본값 설정에서 변경 가능합니다.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
}
// 바디 만들기
Widget makeBody(BuildContext context) {

  return Container(
    child: ScrollConfiguration(
      behavior: NoBehavior(),
      child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Center(
                    child: Column(
                      //내부를 최소만큼 키움.
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: (MediaQuery.of(context).size.height) / 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  '공유할 피드 작성',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5,
                                ),
                              ),
                            ],
                          ),
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
                      ],
                    ),
                  )
              ),
            ],
          )
      ),
    ),
  );
}