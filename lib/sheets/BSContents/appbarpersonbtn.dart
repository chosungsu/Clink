// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clickbyme/Tool/AndroidIOS.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../BACKENDPART/Api/LoginApi.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../BACKENDPART/ViewPoints/SettingVP.dart';
import '../../Tool/pickimage.dart';
import '../../sheets/BottomSheet/AddContentWithBtn.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/TextSize.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';
import '../BottomSheet/AddContent.dart';

final peopleadd = Get.put(UserInfo());
final uiset = Get.put(uisetting());
final draw = Get.put(navibool());

Widgets_personinfo(context, controller, searchnode) {
  Widget title, content, btn;

  title = const SizedBox();
  content = Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GetBuilder<UserInfo>(
        builder: (_) {
          return GestureDetector(
              onTap: () {
                Get.back();
                title =
                    Widgets_personchange(context, controller, searchnode, 0)[0];
                content =
                    Widgets_personchange(context, controller, searchnode, 0)[1];
                AddContent(context, title, content, searchnode);
              },
              child: peopleadd.usrimgurl != ''
                  ? Container(
                      height: 110,
                      width: 110,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: draw.color_textstatus, width: 1)),
                      child: Stack(
                        children: [
                          Positioned(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              File(peopleadd.usrimgurl.contains('media') == true
                                  ? peopleadd.usrimgurl.toString().substring(6)
                                  : peopleadd.usrimgurl),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )),
                          const Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                MaterialCommunityIcons
                                    .image_filter_center_focus_weak,
                                size: 30,
                                color: Colors.blue,
                              )),
                        ],
                      ))
                  : Stack(
                      children: [
                        Positioned(
                          child: Container(
                            height: 110,
                            width: 110,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: draw.color_textstatus, width: 1)),
                            child: Icon(
                              Octicons.person,
                              size: 30,
                              color: draw.color_textstatus,
                            ),
                          ),
                        ),
                        const Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              MaterialCommunityIcons
                                  .image_filter_center_focus_weak,
                              size: 30,
                              color: Colors.blue,
                            )),
                      ],
                    ));
        },
      ),
      GestureDetector(
          onTap: () async {
            Get.back();
            Clipboard.setData(ClipboardData(text: peopleadd.usrcode))
                .whenComplete(() {
              Snack.snackbars(
                  context: context,
                  title: '클립보드에 복사되었습니다.',
                  backgroundcolor: Colors.green,
                  bordercolor: draw.backgroundcolor);
            });
          },
          child: ListTile(
            leading: const Icon(
              MaterialIcons.fiber_pin,
              size: 30,
              color: Colors.black,
            ),
            title: Text('고유코드',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            subtitle: SelectableText(peopleadd.usrcode,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            trailing: Icon(Ionicons.copy_outline,
                size: 30, color: Colors.blue.shade400),
          )),
      GestureDetector(
          onTap: () async {
            Get.back();
            uiset.checktf(true);
            title = Widgets_settingpagenickchange(
                context, controller, searchnode)[0];
            content = Widgets_settingpagenickchange(
                context, controller, searchnode)[1];
            btn = Widgets_settingpagenickchange(
                context, controller, searchnode)[2];
            AddContentWithBtn(context, title, content, btn, searchnode);
          },
          child: ListTile(
            leading: const Icon(
              MaterialCommunityIcons.rename_box,
              size: 30,
              color: Colors.black,
            ),
            title: Text('닉네임 변경',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            subtitle: SelectableText(peopleadd.nickname,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            trailing: const Icon(
              MaterialIcons.chevron_right,
              size: 30,
              color: Colors.black,
            ),
          )),
    ],
  );
  return [title, content];
}
