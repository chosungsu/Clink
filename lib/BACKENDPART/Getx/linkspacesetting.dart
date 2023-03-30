// ignore_for_file: camel_case_types

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
