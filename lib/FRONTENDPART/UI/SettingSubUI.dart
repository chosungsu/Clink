// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Enums/Expandable.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/AndroidIOS.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(PeopleAdd());
final draw = Get.put(navibool());

///UI
///
///ProfilePage의 UI
UI(scrollcontroller, maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    return SingleChildScrollView(
        controller: scrollcontroller,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  uiset.profileindex == 1
                      ? TestScreen(maxWidth, maxHeight)
                      : LicenseScreen(maxWidth, maxHeight),
                ],
              ));
        }));
  });
}

///TestScreen
///
///실험실 공간으로 같은 페이지를 UI변경.
TestScreen(maxWidth, maxHeight) {
  return GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Responsivelayout(
              lstestview(maxWidth, maxHeight), prtestview(maxWidth, maxHeight))
        ],
      ),
    ),
  );
}

lstestview(maxWidth, maxHeight) {
  return responsivewidget(
      SizedBox(
        height: maxHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                AntDesign.frowno,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '새로운 잇플\'s Box들을 열심히 개발중이에요~~!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: contentTextsize(), color: draw.color_textstatus),
              ),
            ]),
      ),
      maxWidth);
}

prtestview(maxWidth, maxHeight) {
  return responsivewidget(
      SizedBox(
        height: maxHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                AntDesign.frowno,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '새로운 잇플\'s Box들을 열심히 개발중이에요~~!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: contentTextsize(), color: draw.color_textstatus),
              ),
            ]),
      ),
      maxWidth);
}

///LicenseHome
///
///앱이 사용한 라이선스 리스트를 보여주는 공간으로 같은 페이지 UI변경.
LicenseScreen(maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Responsivelayout(lslicenseview(maxWidth, maxHeight),
                prlicenseview(maxWidth, maxHeight))
          ],
        ),
      ),
    );
  });
}

lslicenseview(maxWidth, maxHeight) {
  return SizedBox(
      width: maxWidth * 0.6, height: maxHeight, child: buildPanel());
}

prlicenseview(maxWidth, maxHeight) {
  return SizedBox(height: maxHeight, child: buildPanel());
}

buildPanel() {
  return StatefulBuilder(
    builder: (context, setState) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: ExpansionPanelList(
            expansionCallback: ((panelIndex, isExpanded) {
              setState(() {
                licensedata[panelIndex].isExpanded = !isExpanded;
              });
            }),
            dividerColor: Colors.grey,
            children: licensedata.map<ExpansionPanel>((Expandable expandable) {
              return ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.grey.shade300,
                  headerBuilder: ((context, isExpanded) {
                    return ListTile(
                      title: Text(
                        expandable.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: draw.color_textstatus),
                      ),
                    );
                  }),
                  body: ListTile(
                    subtitle: Text(
                      expandable.sub,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentsmallTextsize(),
                          color: draw.color_textstatus),
                    ),
                  ),
                  isExpanded: expandable.isExpanded);
            }).toList()),
      );
    },
  );
}
