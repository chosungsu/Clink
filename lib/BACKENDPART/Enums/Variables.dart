// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:math';
import 'package:clickbyme/BACKENDPART/Enums/Event.dart';
import 'package:clickbyme/FRONTENDPART/Page/NotiAlarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import '../../FRONTENDPART/Page/MYPage.dart';
import '../../FRONTENDPART/Page/ProfilePage.dart';
import '../../FRONTENDPART/Page/SearchPage.dart';
import '../Getx/PeopleAdd.dart';
import '../Getx/linkspacesetting.dart';
import '../Getx/navibool.dart';
import '../Getx/notishow.dart';
import '../Getx/selectcollection.dart';
import '../Getx/uisetting.dart';
import 'Expandable.dart';
import 'MemoList.dart';

//Here are general Variables
var baseurl = 'http://54.65.249.132:8000';
var usercode = Hive.box('user_setting').get('usercode') ?? '';
var appnickname = Hive.box('user_info').get('id') ?? '';
var useremail = Hive.box('user_info').get('email') ?? '';
final linkspaceset = Get.put(linkspacesetting());
final uiset = Get.put(uisetting());
final draw = Get.put(navibool());
final notilist = Get.put(notishow());
final peopleadd = Get.put(PeopleAdd());
final scollection = Get.put(selectcollection());
FirebaseFirestore firestore = FirebaseFirestore.instance;
List pages = [
  const MYPage(),
  const SearchPage(),
  const NotiAlarm(),
  const ProfilePage(),
];
//Here are PageUI Variables
//Here are SpaceinUI Variables
var spacefamilyid;
var spacefamilytype;
var spacefamilyindex;
//Here are Paper Variables
var spacestr;
var unique;
var familyid;
//Here are SearchPage Variables
bool isbought = false;
var textchangelistener = '';
var docid = '';
var checkid = '';
//Here are ProfilePage Variables
bool showsharegroups = false;
final friendnamelist = [];
late PackageInfo info;
String versioninfo = '';
List<Expandable> licensedata = [];
//Here are DayScript Variables
DateTime selectedDay = DateTime.now();
var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random rnd = Random();
bool isresponsible = false;
final imagePicker = ImagePicker();
late Map<DateTime, List<Event>> events;
late List finallist;
String selectedValue = '선택없음';
bool isChecked_pushalarm = false;
int differ_date = 0;
List differ_list = [];
List<bool> alarmtypes = [false, false];
var isChecked_pushalarmwhat = 0;
String hour = '';
String minute = '';
List valueid = [];
List savepicturelist = [];
List<bool> checkbottoms = [
  false,
  false,
  false,
];
List<bool> checkdayyang = [
  true,
  false,
];
bool ischeckedtohideminus = false;
List<MemoList> checklisttexts = [];
Color color = Colors.white;
Color colorfont = Colors.black;
List<int> lunar = [];
List<int> solar = [];