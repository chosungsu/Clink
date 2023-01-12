// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../Route/mainroute.dart';
import '../Route/subuiroute.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../UI(Widget/QR_UI.dart';

class QRPage extends StatefulWidget {
  const QRPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  final int type;
  @override
  State<StatefulWidget> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  late List<TextEditingController> texteditingcontrollerlist;
  List<FocusNode> focusnodelist =
      List<FocusNode>.generate(5, ((index) => FocusNode()));

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 6);
    Hive.box('user_setting').put('addtype', '리스트뷰');
    texteditingcontrollerlist =
        List<TextEditingController>.generate(5, ((index) {
      return TextEditingController();
    }));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (int i = 0; i < texteditingcontrollerlist.length; i++) {
      texteditingcontrollerlist[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGColor(),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: UI(),
          ),
        ));
  }

  UI() {
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppBarCustom(
                              title: '추가하기',
                              lefticon: false,
                              lefticonname: Ionicons.add_outline,
                              righticon: false,
                              doubleicon: false,
                              righticonname: Ionicons.ios_list_outline),
                          const SizedBox(
                            height: 20,
                          ),
                          Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                child: ScrollConfiguration(
                                    behavior: NoBehavior(),
                                    child: LayoutBuilder(
                                      builder: ((context, constraint) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: QR_UI(
                                              constraint.maxWidth,
                                              constraint.maxHeight,
                                              texteditingcontrollerlist,
                                              focusnodelist,
                                              widget.type),
                                        );
                                      }),
                                    )),
                              )),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      draw.setnavi();
      Hive.box('user_setting').put('page_index', 0);
      Get.to(
          () => const mainroute(
                index: 0,
              ),
          transition: Transition.downToUp);
      //Get.back();
    });
    return false;
  }
}
