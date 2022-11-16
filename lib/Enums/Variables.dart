// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

import '../DB/Linkpage.dart';
import '../DB/PageList.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Getx/uisetting.dart';

//Here are general Variables
var usercode = Hive.box('user_setting').get('usercode') ?? '';
var name = Hive.box('user_info').get('id') ?? '';
final linkspaceset = Get.put(linkspacesetting());
final uiset = Get.put(uisetting());
final draw = Get.put(navibool());
final notilist = Get.put(notishow());
final peopleadd = Get.put(PeopleAdd());
final scollection = Get.put(selectcollection());
final searchNode = FocusNode();
FirebaseFirestore firestore = FirebaseFirestore.instance;
bool serverstatus = Hive.box('user_info').get('server_status');
//Here are PageUI Variables
var pagename;
var spacename;
var type;
//Here are MYPage Variables
final List<Linkpage> listpinlink = [];
final List<CompanyPageList> listcompanytousers = [];
ValueNotifier<bool> isDialOpen = ValueNotifier(false);
//Here are SearchPage Variables
bool isbought = false;
var textchangelistener = '';
var docid = '';
var checkid = '';
//Here are ProfilePage Variables
bool showsharegroups = false;
final List<String> list_app_setting = <String>[
  '배경색',
  '글자크기',
  '메뉴바 위치',
];
final List<String> list_user_setting = <String>[
  '개인정보 수집 및 이용 동의',
  '라이선스',
];
final friendnamelist = [];
late PackageInfo info;
String versioninfo = '';
int pagesetnumber = 0;
