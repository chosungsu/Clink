import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/SpaceAD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../Tool/NoBehavior.dart';

class ChangeSpace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeSpaceState();
}

class _ChangeSpaceState extends State<ChangeSpace> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<SpaceList> _list_ad = [
    SpaceList(
      title: '날씨조각',
      image: 'assets/images/date.png',
    ),
    SpaceList(
      title: '일정조각',
      image: 'assets/images/date.png',
    ),
    SpaceList(
      title: '루틴조각',
      image: 'assets/images/run.png',
    ),
    SpaceList(
      title: '운동조각',
      image: 'assets/images/date.png',
    ),
    SpaceList(
      title: '메모조각',
      image: 'assets/images/book.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: EnterMySpace(),
    ));
  }

  EnterMySpace() {
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
                    const Padding(padding: EdgeInsets.only(left: 10)),
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
                                style: const NeumorphicStyle(
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
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: const Text(
                                    '',
                                    style: TextStyle(
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MySpace(height, context),
                              const SizedBox(
                                height: 30,
                              ),
                              ChoiceSpace(height, context),
                              const SizedBox(
                                height: 150,
                              ),
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

  MySpace(double height, BuildContext context) {
    return SizedBox(
      height: 70 * _list_ad.length.toDouble() + 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('나의 현재 스페이스',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          myspace()
        ],
      ),
    );
  }

  myspace() {
    return SizedBox(
        height: 70 * _list_ad.length.toDouble(),
        child: ReorderableListView(
            children: getItems(),
            onReorder: (oldIndex, newIndex) {
              onreorder(oldIndex, newIndex);
            }));
  }

  List<ListTile> getItems() => _list_ad
      .asMap()
      .map((index, item) => index < 3
          ? MapEntry(index, buildListTile_not_buy(item.title, index))
          : MapEntry(index, buildListTile_after_buy(item.title, index)))
      .values
      .toList();
  ListTile buildListTile_not_buy(String item, int index) => ListTile(
      key: ValueKey(item),
      title: Text(item),
      trailing: const Icon(
        Icons.menu,
        color: Colors.black45,
        size: 20,
      ));
  ListTile buildListTile_after_buy(String item, int index) => ListTile(
      key: ValueKey(item),
      title: Text(item),
      trailing: const Icon(
        Icons.lock,
        color: Colors.black45,
        size: 20,
      ));
  onreorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      String titling = _list_ad[oldIndex].title;
      String imaging = _list_ad[oldIndex].image;
      _list_ad.removeAt(oldIndex);
      _list_ad.insert(newIndex, SpaceList(title: titling, image: imaging));
    });
  }

  ChoiceSpace(double height, BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('더 많은 스페이스를 원하신다면?',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SpaceEventAD()
        ],
      ),
    );
  }

  SpaceEventAD() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [SpaceAD()],
    );
  }
}
