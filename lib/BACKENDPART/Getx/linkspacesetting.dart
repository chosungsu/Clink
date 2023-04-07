// ignore_for_file: camel_case_types

import 'package:clickbyme/BACKENDPART/Enums/BoxSelection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Enums/Linkpage.dart';
import '../../Tool/BGColor.dart';

class linkspacesetting extends GetxController {
  List<MainPageLinkList> alllist = [];
  List<MainPageLinkList> addlist = [];
  int clickmainoption = 0;
  String shareoption = 'no';
  int pageviewnum = 0;
  String previewpageimgurl = '';
  List<BoxSelection> boxtypelist = [];
  String pageboxtype = '';
  List<int> getindex = [];
  int boxpreviewnum = 0;
  int pageboxtotalnum = 0;
  String searchurl = '';
  List spacelink = [];
  List indexcnt = [];
  List indextreecnt = [];
  List<List> indextreetmp = [];
  List<Linkspacepageenter> inindextreetmp = [];
  List<LinkofPapers> inpapertreetmp = [];
  List changeurllist = [];
  List setloadingfile = [];
  bool iscompleted = false;
  PlatformFile? pickedFilefirst;
  List? selectedfile;
  List<bool> ischecked = List.filled(10000, false);
  List<bool> islongchecked = List.filled(10000, false);
  String pickedimg = '';
  Color color = Hive.box('user_setting').get('colorlinkpage') != null
      ? Color(Hive.box('user_setting').get('colorlinkpage'))
      : BGColor();

  ///setmainoption
  ///
  ///메인페이지에서 옵션을 선택하는 데에 사용된다.
  void setmainoption(int i) {
    clickmainoption = i;

    update();
    notifyChildrens();
  }

  ///setshareoption
  ///
  ///생성페이지에서 공유여부 옵션을 선택하는 데에 사용된다.
  void setshareoption(what) {
    shareoption = what;

    update();
    notifyChildrens();
  }

  ///setpageimg
  ///
  ///페이지의 이미지를 생성하는 데에 사용된다.
  void setpageimg(String imgurl) {
    previewpageimgurl = imgurl;

    update();
    notifyChildrens();
  }

  ///setpageviewnum
  ///
  ///생성페이지의 페이지뷰 이벤트에 사용된다.
  void setpageviewnum(int i) {
    pageviewnum = i;

    update();
    notifyChildrens();
  }

  ///setindex
  ///
  ///넥스트 박스의 content를 보기위한 인덱싱에 사용된다.
  setboxindex(i) {
    getindex.add(i);

    update();
    notifyChildrens();
  }

  ///homeviewname
  ///
  ///홈뷰 변경에 사용한다.
  void boxpreviewnumset(what) {
    if (what == 'minus') {
      if (boxpreviewnum == 0) {
      } else {
        boxpreviewnum -= 1;
      }
    } else if (what == 'plus') {
      if (pageboxtotalnum == boxpreviewnum + 1) {
      } else {
        boxpreviewnum += 1;
      }
    } else {
      boxpreviewnum = what;
    }

    update();
    notifyChildrens();
  }

  ///setpagetotalviewnum
  ///
  ///생성페이지의 페이지뷰 이벤트에 사용된다.
  void setpagetotalviewnum(int i) {
    if (i == 0) {
    } else {
      pageboxtotalnum = i;
    }

    update();
    notifyChildrens();
  }

  ///setpageboxtypelist
  ///
  ///생성페이지의 박스 리스트 생성에 사용된다.
  void setpageboxtypelist(what) {
    boxtypelist.add(what);

    update();
    notifyChildrens();
  }

  ///setpageboxtype
  ///
  ///생성페이지의 박스명 표기에 사용된다.
  void setpageboxtype(what) {
    pageboxtype = what;

    update();
    notifyChildrens();
  }

  void setalllist(what) {
    alllist.add(what);

    update();
    notifyChildrens();
  }

  void setaddlist(what) {
    addlist.add(what);

    update();
    notifyChildrens();
  }

  void setsearchurl(what) {
    searchurl = what;

    update();
    notifyChildrens();
  }

  void setindextreetmp() {
    indextreetmp.add(List.empty(growable: true));
    update();
    notifyChildrens();
  }

  void setindexofcheckbox(int index, bool what) {
    ischecked[index] = what;
    update();
    notifyChildrens();
  }

  void resetindexofcheckbox() {
    ischecked = List.filled(10000, false);
    update();
    notifyChildrens();
  }

  void setsearchfile(
    PlatformFile first,
    List filenames,
  ) {
    pickedFilefirst = first;
    selectedfile = filenames;
    update();
    notifyChildrens();
  }

  void removesearchfile(int index) {
    selectedfile!.removeAt(index);
    update();
    notifyChildrens();
  }

  void resetsearchfile() {
    pickedFilefirst = null;
    selectedfile = [];
    update();
    notifyChildrens();
  }

  void setsearchimage(String what) {
    pickedimg = what;
    update();
    notifyChildrens();
  }

  void setspacelink(String title) {
    spacelink.add(title);
    update();
    notifyChildrens();
  }

  void resetspacelink() {
    spacelink.clear();
    update();
    notifyChildrens();
  }

  void setcompleted(bool what) {
    iscompleted = what;
    update();
    notifyChildrens();
  }

  void resetcompleted() {
    iscompleted = false;
    update();
    notifyChildrens();
  }

  void setcolor() {
    color = Color(Hive.box('user_setting').get('colorlinkpage'));
    update();
    notifyChildrens();
  }

  void setspacein(dynamic dynamics) {
    indexcnt.add(dynamics);
    update();
    notifyChildrens();
  }

  void setspecificspacein(int index, dynamic dynamics) {
    indexcnt.insert(index, dynamics);
    update();
    notifyChildrens();
  }

  void minusspacein(int index) {
    indexcnt.removeAt(index);
    update();
    notifyChildrens();
  }

  void setspacetreein(dynamic dynamics) {
    indextreecnt.add(dynamics);
    update();
    notifyChildrens();
  }

  void setspecificspacetreein(int index, dynamic dynamics) {
    indextreecnt.insert(index, dynamics);
    update();
    notifyChildrens();
  }

  void minusspacetreein(int index) {
    indextreecnt.removeAt(index);
    update();
    notifyChildrens();
  }
}
