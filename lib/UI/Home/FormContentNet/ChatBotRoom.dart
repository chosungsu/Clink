import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatBotRoom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatBotRoomState();
}

class _ChatBotRoomState extends State<ChatBotRoom> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List listchatbot = [
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  final List listchat = [
    '5',
    '6',
    '7',
    '8',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
    '9',
    '10',
    '11',
    '12',
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: UI(),
    ));
  }

  UI() {
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
                                            style: const NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: Colors.black45,
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
                                              child: Text(
                                                'Chatty',
                                                style: GoogleFonts.lobster(
                                                fontSize: 23,
                                                //color: widget.coloritems,
                                                fontWeight: FontWeight.bold,
                                              )
                                              ),
                                            ),
                                          ],
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: AdBox(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ChatBox(),
              ),
            ],
          )),
    );
  }

  AdBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  ChatBox() {
    return Container(
      child: Chat(),
      decoration: BoxDecoration(
          color: MyTheme.kPrimaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
    );
  }

  Chat() {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 170,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: listchat.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue.shade500,
                                    child: const Icon(
                                      Icons.smart_toy,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              decoration: BoxDecoration(
                                  color: MyTheme.chatbotColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                              child: Text(
                                listchatbot[index].toString(),
                                style: MyTheme.bodyTextMessage,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              decoration: BoxDecoration(
                                  color: MyTheme.userchatColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  )),
                              child: Text(
                                listchat[index].toString(),
                                style: MyTheme.bodyTextMessage,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue.shade500,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: ''),
                    ),
                  ),
                  Icon(
                    Icons.send,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
