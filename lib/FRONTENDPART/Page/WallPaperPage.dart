// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names
import 'package:clickbyme/BACKENDPART/Getx/linkspacesetting.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../Route/mainroute.dart';
import '../Route/subuiroute.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/Loader.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../UI(Widget/WallPaperUI.dart';

class WallPaperPage extends StatefulWidget {
  const WallPaperPage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<StatefulWidget> createState() => _WallPaperPageState();
}

class _WallPaperPageState extends State<WallPaperPage> {
  final linkspaceset = Get.put(linkspacesetting());
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
    uiset.pagenumber = 4;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onWillPop() async {
    uiset.setpageindex(0);
    Get.to(() => const mainroute(), transition: Transition.fade);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            bottomNavigationBar: ADSHOW(),
            backgroundColor: draw.backgroundcolor,
            body: SafeArea(
                child: GetBuilder<linkspacesetting>(
              builder: (_) => WillPopScope(
                onWillPop: onWillPop,
                child: Stack(
                  children: [
                    MainBody(),
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

  Widget MainBody() {
    double height = MediaQuery.of(context).size.height;
    return OrientationBuilder(builder: ((context, orientation) {
      return SizedBox(
          height: height,
          child: Container(
              color: draw.backgroundcolor,
              child: Column(
                children: [
                  AppBarCustom(
                    title: linkspaceset.indexcnt[widget.index].placestr,
                    lefticon: false,
                    righticon: true,
                    doubleicon: false,
                    lefticonname: SimpleLineIcons.grid,
                    righticonname: SimpleLineIcons.grid,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      child: ScrollConfiguration(
                          behavior: NoBehavior(),
                          child: LayoutBuilder(
                            builder: ((context, constraint) {
                              return UI(
                                  linkspaceset
                                      .indexcnt[widget.index].familycode,
                                  constraint.maxWidth,
                                  constraint.maxHeight);
                            }),
                          ))),
                ],
              )));
    }));
  }

  /*Speeddialspace(
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
  }*/
}
