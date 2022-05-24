import 'package:clickbyme/UI/Analytics/ShareView.dart';
import 'package:clickbyme/UI/Analytics/ReportView.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../Tool/NoBehavior.dart';
import 'DrawerScreen.dart';

class AnalyticPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage>
    with TickerProviderStateMixin {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  final PageController _pController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          DrawerScreen(),
          AnalyticBody(context, _pController),
        ],
      ),
    ));
  }

  Widget AnalyticBody(BuildContext context, PageController pController) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: Duration(milliseconds: 250),
      child: SizedBox(
        height: height,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 10)),
                      SizedBox(
                          width: 50,
                          child: isdraweropen
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      xoffset = 0;
                                      yoffset = 0;
                                      scalefactor = 1;
                                      isdraweropen = false;
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
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  ))
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      xoffset = 50;
                                      yoffset = 0;
                                      scalefactor = 1;
                                      isdraweropen = true;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    child: NeumorphicIcon(
                                      Icons.menu,
                                      size: 30,
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          surfaceIntensity: 0.5,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  ))),
                      const SizedBox(
                          child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('데이 연구실',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.85,
                  child: ScrollConfiguration(
                    behavior: NoBehavior(),
                    child: SingleChildScrollView(child:
                        StatefulBuilder(builder: (_, StateSetter setState) {
                      return Column(
                        children: [
                          A_Container1(height),
                          A_Container2(height),
                          SizedBox(
                            height: height * 0.2,
                          ),
                        ],
                      );
                    })),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

A_Container1(double height) {
  return SizedBox(
    height: height * 0.4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('하루 분석',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Day Analysis',
                          style: TextStyle(
                              color: Colors.orange,
                              fontStyle: FontStyle.italic,
                              fontSize: 13)),
                    ],
                  ),
                ),
                /*Container(
                  alignment: Alignment.center,
                  width: 25,
                  height: 25,
                  child: NeumorphicIcon(
                    Icons.download,
                    size: 25,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.black45,
                        lightSource: LightSource.topLeft),
                  ),
                )*/
              ],
            )),
        ReportView(height: height),
      ],
    ),
  );
}

A_Container2(double height) {
  return SizedBox(
    height: height * 0.4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('공유 활동 현황',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Share Points',
                          style: TextStyle(
                              color: Colors.orange,
                              fontStyle: FontStyle.italic,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            )),
        ShareView(height: height),
      ],
    ),
  );
}
