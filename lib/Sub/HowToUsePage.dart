import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../Tool/BGColor.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../Tool/IconBtn.dart';

class HowToUsePage extends StatefulWidget {
  const HowToUsePage({
    Key? key,
    required this.eventtotaltitle,
    required this.eventtotalcontent,
    required this.eventname,
  }) : super(key: key);
  final List eventtotaltitle;
  final List eventtotalcontent;
  final String eventname;
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
  List eventtitle = [];

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
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize(),
                                        color: TextColor()),
                                  ),
                                ),
                                IconBtn(
                                    child: IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.close,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        )),
                                    color: TextColor())
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
                  text: widget.eventname.toString(),
                  style: TextStyle(
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
    List eventsmalltitles = [];
    List eventsmallcontents = [];
    for (int i = 0; i < widget.eventtotaltitle.length; i++) {
      eventsmalltitles.add(widget.eventtotaltitle[i]);
      eventsmallcontents.add(widget.eventtotalcontent[i]);
    }
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: eventsmalltitles.length,
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
                                eventsmalltitles[index].toString(),
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
                        title: Text(eventsmallcontents[index].toString(),
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
        });
  }
}
