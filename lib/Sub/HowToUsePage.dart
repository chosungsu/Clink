import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../Tool/BGColor.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';

class HowToUsePage extends StatefulWidget {
  const HowToUsePage({
    Key? key,
    required this.stringsend,
  }) : super(key: key);
  final String stringsend;
  @override
  State<StatefulWidget> createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage>
    with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  List eventsmalltitle = [];
  List eventsmallcontent = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
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
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        60 -
                                        160,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text('',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 23,
                                                    //color: widget.coloritems,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ],
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  )),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              BuildTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              BuildContent(),
                              const SizedBox(
                                height: 50,
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

  BuildTitle() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(
                  text: widget.stringsend + '를 다음과 같이\n사용해보세요~',
                  style: GoogleFonts.jua(
                    fontSize: secondTitleTextsize(),
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                  )),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          )
        ],
      ),
    );
  }

  BuildContent() {
    List<Widget> list_all = [];
    return FutureBuilder(
        future: firestore
            .collection("EventNoticeDataBase")
            .where('eventpage', isEqualTo: 'home')
            .where('eventname',
                isEqualTo: widget.stringsend == '캘린더'
                    ? '일정관리는 이렇게!'
                    : (widget.stringsend == '메모'
                        ? '메모에 숨겨진 다양한 기능'
                        : 'PDF 형식 지원'))
            .get()
            .then(((QuerySnapshot querySnapshot) => {
                  eventsmalltitle.clear(),
                  eventsmallcontent.clear(),
                  querySnapshot.docs.forEach((doc) {
                    for (int i = 0;
                        i < doc.get('pagesmalltitles').length;
                        i++) {
                      eventsmalltitle.add(doc.get('pagesmalltitles')[i]);
                      eventsmallcontent.add(doc.get('pagesmallcontent')[i]);
                    }
                  })
                })),
        builder: (context, future) {
          if (future.hasData) {
            list_all = <Widget>[
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: eventsmalltitle.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ContainerDesign(
                            child: Column(
                              children: [
                                ListTile(
                                  horizontalTitleGap: 10,
                                  dense: true,
                                  title: Text(
                                      (index + 1).toString() +
                                          '.  ' +
                                          eventsmalltitle[index].toString(),
                                      style: TextStyle(
                                        color: TextColor(),
                                        fontSize: contentTextsize(),
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Divider(
                                  color: TextColor_shadowcolor(),
                                  thickness: 1,
                                  endIndent: 30,
                                  indent: 30,
                                ),
                                ListTile(
                                  horizontalTitleGap: 10,
                                  dense: true,
                                  title:
                                      Text(eventsmallcontent[index].toString(),
                                          style: TextStyle(
                                            color: TextColor_shadowcolor(),
                                            fontSize: contentTextsize(),
                                          )),
                                ),
                              ],
                            ),
                            color: BGColor()),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  })
            ];
          } else if (future.hasError) {
            list_all = <Widget>[
              ContainerDesign(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child:
                            Text('서버에 해당 이벤트 내용이 존재하지 않습니다. 오류가 지속되면 문의바랍니다.',
                                style: TextStyle(
                                  color: TextColor(),
                                  fontWeight: FontWeight.bold,
                                )),
                      )
                    ],
                  ),
                  color: BGColor())
            ];
          } else if (future.connectionState == ConnectionState.waiting) {
            list_all = <Widget>[
              ContainerDesign(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(child: CircularProgressIndicator())
                    ],
                  ),
                  color: BGColor())
            ];
          } else {
            list_all = <Widget>[
              ContainerDesign(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child:
                            Text('서버에 해당 이벤트 내용이 존재하지 않습니다. 오류가 지속되면 문의바랍니다.',
                                style: TextStyle(
                                  color: TextColor(),
                                  fontWeight: FontWeight.bold,
                                )),
                      )
                    ],
                  ),
                  color: BGColor())
            ];
          }
          return Column(children: list_all);
        });
  }
}
