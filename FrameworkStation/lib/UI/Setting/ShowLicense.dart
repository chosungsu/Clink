import 'dart:io';
import 'package:clickbyme/DB/Expandable.dart';
import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/licenseget.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:get/get.dart';
import '../../../Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../../Tool/NoBehavior.dart';
import '../../Tool/ContainerDesign.dart';

class ShowLicense extends StatefulWidget {
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
  List<Expandable> _data = [];
  List listid_list = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final getlicense = Get.put(licenseget());

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
    /*firestore.collection("AppLicense").get().then((value) {
      listid_list = value.docs.id;
    }).whenComplete(() {
      for (int i = 1; i < listid_list + 1; i++) {
        firestore.collection("AppLicense").doc('$i').get().then((value) {
          /*eventsmalltitle.add(value.get('licensetitle'));
          eventsmallcontent.add(value.get('content'));*/
          getlicense.setlicense(
              value.get('licensetitle'), value.get('content'));
          _data.insert(
              0,
              Expandable(
                  title: value.get('licensetitle'),
                  sub: value.get('content'),
                  isExpanded: false));
        });
      }
    });*/
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
      body: license(),
    ));
  }

  license() {
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
    );
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
              backgroundColor: TextColor_shadowcolor(),
              headerBuilder: ((context, isExpanded) {
                return ListTile(
                  title: Text(
                    expandable.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: BGColor()),
                  ),
                );
              }),
              body: ListTile(
                subtitle: Text(
                  expandable.sub,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: BGColor_shadowcolor()),
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
