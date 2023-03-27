// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BACKENDPART/Api/NoticeApi.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(UserInfo());
final draw = Get.put(navibool());

///UI
///
///SettingSubPage의 UI
UI(maxWidth, maxHeight) {
  return responsivewidget(GetBuilder<uisetting>(builder: (_) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: uiset.profileindex == 0
            ? AppnotiScreen(maxWidth, maxHeight)
            : (uiset.profileindex == 1
                ? TestScreen(maxWidth, maxHeight - 20)
                : LicenseScreen(maxWidth, maxHeight)));
  }), maxWidth);
}

///TestScreen
///
///실험실 공간으로 같은 페이지를 UI변경.
AppnotiScreen(maxWidth, maxHeight) {
  return SizedBox(child: notiview(maxWidth, maxHeight));
}

notiview(maxWidth, maxHeight) {
  return SizedBox(
      height: maxHeight,
      child: FutureBuilder(
        future: NoticeApiProvider().getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitThreeBounce(
              size: 30,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade200, shape: BoxShape.circle),
                );
              },
            );
          } else {
            return GetBuilder<notishow>(
              builder: (_) {
                return notilist.listappnoti.isEmpty || notilist.clicker == 1
                    ? NotInPageScreen(maxWidth, maxHeight)
                    : view(maxWidth, maxHeight);
              },
            );
          }
        },
      ));
}

NotInPageScreen(width, height) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    height: height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          '해당 페이지는 비어있습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: contentTextsize(), color: draw.color_textstatus),
        ),
      ],
    ),
  );
}

view(width, height) {
  return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: notilist.listappnoti.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ContainerDesign(
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notilist.listappnoti[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: draw.color_textstatus),
                        ),
                        Divider(
                          height: 3,
                          color: draw.color_textstatus,
                          thickness: 1,
                          indent: 0,
                          endIndent: 30,
                        ),
                        Text(
                          notilist.listappnoti[index].content,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentsmallTextsize(),
                              color: draw.color_textstatus),
                        ),
                      ],
                    ),
                  ),
                  color: draw.backgroundcolor),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ));
}

///TestScreen
///
///실험실 공간으로 같은 페이지를 UI변경.
TestScreen(maxWidth, maxHeight) {
  return SizedBox(child: testview(maxWidth, maxHeight));
}

testview(maxWidth, maxHeight) {
  return SizedBox(
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
  );
}

///LicenseHome
///
///앱이 사용한 라이선스 리스트를 보여주는 공간으로 같은 페이지 UI변경.
LicenseScreen(maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    return SizedBox(child: buildPanel(maxWidth));
  });
}

buildPanel(maxWidth) {
  return SizedBox(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: licensedata.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ContainerDesign(
                child: ListTile(
                  title: Text(
                    licensedata[index].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize(),
                        color: draw.color_textstatus),
                  ),
                  trailing: const Icon(
                    FontAwesome.hand_o_right,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onTap: () {
                    var url = Uri.parse(licensedata[index].sub);
                    launchUrl(url);
                  },
                ),
                color: draw.backgroundcolor),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    ),
  );
}
/*ExpansionPanelList(
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
            }).toList()),*/