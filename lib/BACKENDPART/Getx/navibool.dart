// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Tool/MyTheme.dart';

class navibool extends GetxController {
  final box = GetStorage();
  Map settinginsidemap = {};
  bool drawopen = Hive.box('user_setting').get('page_opened') ?? false;
  int currentpage = 1;
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool navishow = Hive.box('user_setting').get('menushowing') ?? true;
  int navi = Hive.box('user_setting').get('which_menu_pick') ?? 0;
  int statusbarcolor = 0;
  int textsize = 0;
  Size size = Get.size;
  Color backgroundcolor = MyTheme.colorWhite;
  Color color_textstatus = MyTheme.colorblack;

  void setappbox() {
    if (box.read('backgroundcolor') == null) {
      box.write('backgroundcolor', MyTheme.colorWhite.value);
    }
    if (box.read('textcolor') == null) {
      box.write('textcolor', MyTheme.colorblack.value);
    }
    if (box.read('statusbarcolor') == null) {
      box.write('statusbarcolor', 0);
    }
    if (box.read('textsize') == null) {
      box.write('textsize', 0);
    }

    backgroundcolor = Color(box.read('backgroundcolor'));
    color_textstatus = Color(box.read('textcolor'));
    statusbarcolor = box.read('statusbarcolor') ?? 0;
    textsize = box.read('textsize') ?? 0;

    update();
    notifyChildrens();
  }

  void changeappbox() {
    if (box.read('backgroundcolor') == MyTheme.colorWhite.value) {
      box.write('backgroundcolor', MyTheme.colorblack.value);
      box.write('textcolor', MyTheme.colorWhite.value);
      box.write('statusbarcolor', 1);
    } else {
      box.write('backgroundcolor', MyTheme.colorWhite.value);
      box.write('textcolor', MyTheme.colorblack.value);
      box.write('statusbarcolor', 0);
    }

    backgroundcolor = Color(box.read('backgroundcolor'));
    color_textstatus = Color(box.read('textcolor'));
    statusbarcolor = box.read('statusbarcolor') ?? 0;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: backgroundcolor,
        statusBarBrightness:
            statusbarcolor == 0 ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            statusbarcolor == 0 ? Brightness.dark : Brightness.light));

    update();
    notifyChildrens();
  }

  void setpagecurrent(int what) {
    currentpage = what;
    update();
    notifyChildrens();
  }

  void clicksettinginside(int integer, bool what) {
    settinginsidemap = {integer: what};
    update();
    notifyChildrens();
  }

  void setopen() {
    if (navishow) {
    } else {
      if (navi == 0) {
        if (Get.width < 1000) {
          xoffset = 60;
        } else {
          xoffset = 120;
        }
      } else {
        if (Get.width < 1000) {
          xoffset = -60;
        } else {
          xoffset = -120;
        }
      }
      yoffset = 0;
      scalefactor = 1;
      drawopen = true;
      Hive.box('user_setting').put('page_opened', drawopen);
    }

    update();
    notifyChildrens();
  }

  void setclose() {
    if (navishow) {
    } else {
      xoffset = 0;
      yoffset = 0;
      scalefactor = 1;
      drawopen = false;
      Hive.box('user_setting').put('page_opened', drawopen);
    }

    update();
    notifyChildrens();
  }

  void setnavi(int what) {
    navi = what;
    Hive.box('user_setting').put('which_menu_pick', what);
    if (navishow) {
      setopen();
    } else {
      setclose();
    }

    update();
    notifyChildrens();
  }

  void setts(int what) {
    ///setts
    ///
    ///글자 크기를 결정
    textsize = what;
    box.write('textsize', what);
    textsize = box.read('textsize');
    update();
    notifyChildrens();
  }

  void setmenushowing(bool what) {
    ///setmenushowing
    ///
    ///메뉴 보이기를 결정
    Hive.box('user_setting').put('menushowing', what);
    navishow = what;
    if (what) {
      setopen();
    } else {
      setclose();
    }
    update();
    notifyChildrens();
  }
}
