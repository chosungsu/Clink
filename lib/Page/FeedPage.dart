import 'package:flutter/material.dart';
import '../DB/Contents.dart';
import '../DB/Home_Rec_title.dart';
import '../DB/TODO.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/UserPicks.dart';
import '../UI/SearchWidget.dart';
import '../UI/UserSubscription.dart';
import 'DrawerScreen.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  /*TabController? _tabController;
  int tabindex = 0;
  String query = '';
  late List<Contents> contents;
  final List<Home_Rec_title> _list_recommend = [
    Home_Rec_title(sub: 'My 피드'),
    Home_Rec_title(sub: 'dot 추천'),
  ];*/
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*_tabController = TabController(length: 2, vsync: this);
    contents = [
      Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
      Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
      Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
      Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
      Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
    ];*/
  }

  /*void searchFeed(String query) {
    final list_feed = contents.where((text) {
      final title = text.title.toLowerCase();
      final content = text.content.toLowerCase();
      final searchQ = query.toLowerCase();
      return title.contains(searchQ) || content.contains(searchQ);
    }).toList();

    setState(() {
      this.query = query;
      contents = list_feed;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    /*setState(() {
      if (_tabController != null) {
        _tabController!.addListener(() {
          setState(() {
            tabindex = _tabController!.index;
          });
        });
      }
    });*/
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            DrawerScreen(),
            FeedBody(context),
          ],
        )
        /*appBar: AppBar(
          toolbarHeight: 130,
          backgroundColor: Colors.white,
          title: Container(
            child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('피드',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent.shade100,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Colors.deepPurpleAccent.shade100,
                        )
                      ],
                    ),
                    buildSearch(context),
                  ],
                )),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),*/
        /*body: 
        CustomScrollView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          scrollBehavior: NoBehavior(),
          slivers: [
            SliverAppBar(
              pinned: true,
              //centerTitle: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      height: MediaQuery.of(context).size.height / 10,
                      child: TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.deepPurpleAccent,
                        controller: _tabController,
                        isScrollable: true,
                        labelPadding: EdgeInsets.only(left: 25, right: 25),
                        indicator:
                            CircleIndicator(color: Colors.black, radius: 4),
                        tabs: [
                          Tab(
                            text: _list_recommend[0].sub.toString(),
                          ),
                          Tab(
                            text: _list_recommend[1].sub.toString(),
                          ),
                        ],
                      ))),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: ContentSub(
                      context, _tabController!, _list_recommend, contents))
          ],)*/
        );
  }
  Widget FeedBody(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: Duration(milliseconds: 250),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.deepPurple.shade200,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: isdraweropen
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                xoffset = 0;
                                yoffset = 0;
                                scalefactor = 1;
                                isdraweropen = false;
                              });
                            },
                            icon: Icon(Icons.keyboard_arrow_left),
                            color: Colors.white,
                            iconSize: 30,
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                xoffset = 180;
                                yoffset = 100;
                                scalefactor = 0.8;
                                isdraweropen = true;
                              });
                            },
                            icon: Icon(Icons.menu),
                            color: Colors.white,
                            iconSize: 30,
                          ),
                  ),
                  SizedBox(
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('탐색',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                    left: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                    right: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                    bottom: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                  ),),
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      UserPicks(context),
                    ])),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 검색창 만들기
  /*Widget buildSearch(BuildContext context) {
    return SearchWidget(
      text: query,
      hintText: '검색하실 제목이나 내용 입력바랍니다.',
      onChanged: (String value) {
        searchFeed(query);
      },
    );
  }*/

// 바디 만들기
  /*Widget makeBody(BuildContext context, TabController? tabController,
      int tabindex, List<Contents> contents) {
    return Column(children: [
      UserSubscription(context, tabController!, tabindex, contents)
    ]);
  }*/
}
