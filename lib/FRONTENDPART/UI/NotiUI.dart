// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Api/NoticeApi.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/ContainerDesign.dart';

final draw = Get.put(navibool());
final uiset = Get.put(uisetting());
final notilist = Get.put(notishow());

UI(width, height) {
  return FutureBuilder(
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
                ? NotInPageScreen(width, height)
                : view(width, height);
          },
        );
      }
    },
  );
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
