// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Enums/Expandable.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/licenseget.dart';
import 'package:clickbyme/Tool/Getx/navibool.dart';
import 'package:get/get.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';

class ShowLicense extends StatefulWidget {
  const ShowLicense({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShowLicenseState();
}

class _ShowLicenseState extends State<ShowLicense> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  bool isChecked = false;
  List eventsmalltitle = List.empty(growable: true);
  List eventsmallcontent = List.empty(growable: true);
  final List<Expandable> _data = [];
  List listid_list = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final getlicense = Get.put(licenseget());
  final draw = Get.put(navibool());

  @override
  void initState() {
    super.initState();
    firestore.collection("AppLicense").doc('License').get().then((value) {
      for (int i = 0; i < value.get('licensetitle').length; i++) {
        getlicense.setlicense(
            value.get('licensetitle')[i], value.get('content')[i]);
        _data.insert(
            0,
            Expandable(
                title: value.get('licensetitle')[i],
                sub: value.get('content')[i],
                isExpanded: false));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGColor(),
        body: SafeArea(
          child: license(),
        ));
  }

  license() {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => SizedBox(
              height: height,
              child: Container(
                  decoration: BoxDecoration(
                    color: draw.backgroundcolor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBarCustom(
                        title: 'License',
                        righticon: false,
                        doubleicon: false,
                        iconname: Icons.close,
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: SizedBox(
                            child: ScrollConfiguration(
                              behavior: NoBehavior(),
                              child: SingleChildScrollView(child:
                                  StatefulBuilder(
                                      builder: (_, StateSetter setState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      LicenseHome(),
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
            ));
  }

  Widget buildPanel() {
    return ExpansionPanelList(
        expansionCallback: ((panelIndex, isExpanded) {
          setState(() {
            _data[panelIndex].isExpanded = !isExpanded;
          });
        }),
        dividerColor: BGColor_shadowcolor(),
        children: _data.map<ExpansionPanel>((Expandable expandable) {
          return ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: Colors.grey.shade300,
              headerBuilder: ((context, isExpanded) {
                return ListTile(
                  title: Text(
                    expandable.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: Colors.black),
                  ),
                );
              }),
              body: ListTile(
                subtitle: Text(
                  expandable.sub,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: Colors.black),
                ),
              ),
              isExpanded: expandable.isExpanded);
        }).toList());
  }

  LicenseHome() {
    return GetBuilder<licenseget>(builder: (_) {
      return buildPanel();
    });
  }
}
