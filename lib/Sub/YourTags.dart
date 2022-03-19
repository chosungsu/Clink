import 'package:clickbyme/DB/Recommend.dart';
import 'package:clickbyme/sheets/onAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import '../DB/Contents.dart';
import '../Tool/NoBehavior.dart';
import '../UI/UserSubscription.dart';

class YourTags extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _YourTagsState();
}

class _YourTagsState extends State<YourTags> with TickerProviderStateMixin {
  late TabController _tabController_tags;
  int tabindex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController_tags = TabController(length: 2, vsync: this);
  }

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
        actions: <Widget>[
          IconButton(
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () => {
              //bottomsheet 사용하기
              onAdd(context),
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
        title: Text('태그 관리', style: TextStyle(color: Colors.blueGrey)),
        bottom: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.deepPurpleAccent,
          controller: _tabController_tags,
          isScrollable: false,
          labelPadding: const EdgeInsets.only(left: 25, right: 25),
          indicator: CircleIndicator(color: Colors.black, radius: 4),
          tabs: [
            Tab(
              text: '피드 태그',
            ),
            Tab(
              text: '사람 태그',
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: makeBody(context, _tabController_tags),
      ),
    );
  }
}

// 바디 만들기
Widget makeBody(BuildContext context, TabController tabController_tags) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final List<Recommend> _list_content = [
    Recommend(sub: '추천 태그'),
    Recommend(sub: '사용자의 태그 보관함'),
    Recommend(sub: '분석'),
  ];
  return TabBarView(
    controller: tabController_tags,
    children: [
      CustomScrollView(
        physics: RangeMaintainingScrollPhysics(),
        scrollBehavior: NoBehavior(),
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 15, left: 15),
                        child: Row(
                          children: [
                            Text(_list_content[index].sub.toString(),
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            const Text('Beta',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ))
                          ],
                        ))
                    : Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 15, left: 15),
                        child: Text(_list_content[index].sub.toString(),
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                index == 0 || index == 1
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: StreamBuilder(
                          stream:
                              firebaseFirestore.collection('Tags').snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    children:
                                        snapshot.data!.docs.map((document) {
                                      return document['name'] ==
                                              Hive.box('user_info').get('id')
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: Neumorphic(
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      boxShape:
                                                          NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                      depth: 4,
                                                      intensity: 0.5,
                                                      color: Colors.white,
                                                      lightSource:
                                                          LightSource.topLeft),
                                                  child: InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                                child: Text(document[
                                                                        'tag_content']
                                                                    .toString()))
                                                          ],
                                                        ),
                                                      ))),
                                            )
                                          : SizedBox(
                                              height: 0,
                                              width: 0,
                                            );
                                    }).toList()));
                          },
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Container(
                          color: Colors.grey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('프로 버전 이상에서 가능한 기능입니다.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ))
                              ]),
                        )),
              ],
            ),
            childCount: _list_content.length,
          ))
        ],
      ),
      Icon(Icons.directions_transit),
    ],
  );
}
