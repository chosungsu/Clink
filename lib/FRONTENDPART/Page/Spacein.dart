// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names
import 'package:clickbyme/BACKENDPART/FIREBASE/PersonalVP.dart';
import 'package:clickbyme/BACKENDPART/Getx/linkspacesetting.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:clickbyme/sheets/linksettingsheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../Enums/Variables.dart';
import '../../Tool/ContainerDesign.dart';
import '../../BACKENDPART/Getx/calendarsetting.dart';
import '../../Tool/TextSize.dart';
import '../Route/subuiroute.dart';
import '../../Tool/BGColor.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/Loader.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../UI(Widget/SpaceinUI.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Spacein extends StatefulWidget {
  const Spacein(
      {Key? key, required this.id, required this.type, required this.spacename})
      : super(key: key);
  final String id;
  final int type;
  final String spacename;

  @override
  State<StatefulWidget> createState() => _SpaceinState();
}

class _SpaceinState extends State<Spacein> with TickerProviderStateMixin {
  var scrollController;
  bool isinit = false;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final linkspaceset = Get.put(linkspacesetting());
  final controll_cals = Get.put(calendarsetting());
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  final DateTime _selectedDay = DateTime.now();
  final DateTime _focusedDay = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('widgetid', widget.id);
    scrollController = ScrollController();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    controll_cals.events = {};
    controll_cals.selectedDay = _selectedDay;
    controll_cals.focusedDay = _focusedDay;
    PageViewStreamChild5(context, widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            bottomNavigationBar: ADSHOW(),
            backgroundColor: draw.backgroundcolor,
            floatingActionButton: widget.type == 0
                ? Speeddialspace(context, widget.id, widget.type)
                : null,
            body: SafeArea(
                child: GetBuilder<linkspacesetting>(
              builder: (_) => WillPopScope(
                onWillPop: _onWillPop,
                child: Stack(
                  children: [
                    UI(),
                    linkspaceset.iscompleted == true
                        ? const Loader(
                            wherein: 'spaceupload',
                          )
                        : Container()
                  ],
                ),
              ),
            ))));
  }

  Widget UI() {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
              ..scale(draw.scalefactor),
            duration: const Duration(milliseconds: 250),
            child: GetBuilder<navibool>(
              builder: (_) => GestureDetector(
                onTap: () {
                  draw.drawopen == true
                      ? setState(() {
                          draw.drawopen = false;
                          draw.setclose();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: SizedBox(
                  height: height,
                  child: Container(
                      color: draw.backgroundcolor,
                      child: Column(
                        children: [
                          widget.type == 1
                              ? FutureBuilder(
                                  future: firestore
                                      .collection('Calendar')
                                      .get()
                                      .then((value) {
                                    if (value.docs.isNotEmpty) {
                                      final valuespace = value.docs;
                                      for (int i = 0;
                                          i < valuespace.length;
                                          i++) {
                                        if (value.docs[i].get('parentid') ==
                                            widget.id) {
                                          setState(() {
                                            isinit = true;
                                          });
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        isinit = false;
                                      });
                                    }
                                  }),
                                  builder: ((context, snapshot) {
                                    if (isinit == true) {
                                      return const SizedBox();
                                    } else {
                                      return SizedBox(
                                        height: 60,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 5,
                                                bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ContainerDesign(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Icon(
                                                        Feather.chevron_left,
                                                        size: 30,
                                                        color: draw
                                                            .color_textstatus,
                                                      ),
                                                    ),
                                                    color:
                                                        draw.backgroundcolor),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                    fit: FlexFit.tight,
                                                    child: SizedBox(
                                                      child: Text(
                                                        widget.spacename,
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                mainTitleTextsize(),
                                                            color: draw
                                                                .color_textstatus),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )),
                                              ],
                                            )),
                                      );
                                    }
                                  }))
                              : (widget.type == 0
                                  ? GetBuilder<uisetting>(
                                      builder: (_) => AppBarCustom(
                                        title: widget.spacename,
                                        lefticon: false,
                                        lefticonname: Icons.add,
                                        righticon: true,
                                        doubleicon: false,
                                        righticonname: Icons.download,
                                        mainid: widget.id,
                                      ),
                                    )
                                  : GetBuilder<uisetting>(
                                      builder: (_) => AppBarCustom(
                                        title: widget.spacename,
                                        lefticon: false,
                                        lefticonname: Icons.add,
                                        righticon: false,
                                        doubleicon: false,
                                        righticonname: Icons.download,
                                        mainid: widget.id,
                                      ),
                                    )),
                          isinit == true
                              ? const SizedBox(
                                  height: 0,
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                          ScrollConfiguration(
                            behavior: NoBehavior(),
                            child: SpaceinUI(widget.id, widget.type, isinit),
                          )
                        ],
                      )),
                ),
              ),
            )));
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () async {
      if (isDialOpen.value == true) {
        isDialOpen.value = false;
      } else {
        StatusBarControl.setColor(draw.backgroundcolor, animated: true);
        draw.setnavi();
        Hive.box('user_setting').put('widgetid', null);
        setState(() {
          isinit = false;
        });
        Get.back();
      }

      //Get.back();
    });
    return false;
  }

  Speeddialspace(
    BuildContext context,
    String mainid,
    int type,
  ) {
    FilePickerResult? res;
    final imagePicker = ImagePicker();

    return GetBuilder<uisetting>(
        builder: (_) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SpeedDial(
                  openCloseDial: isDialOpen,
                  activeIcon: Icons.close,
                  icon: Icons.add,
                  backgroundColor: Colors.blue,
                  overlayColor: BGColor(),
                  overlayOpacity: 0.4,
                  spacing: 10,
                  spaceBetweenChildren: 10,
                  onPress: () {
                    linkspaceset.resetsearchfile();
                    linkplaceshowaddaction(context, mainid);
                  },
                ),
              ],
            ));
  }
}
