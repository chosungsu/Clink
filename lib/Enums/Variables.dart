// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:math';
import 'package:clickbyme/Enums/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Getx/uisetting.dart';
import 'Expandable.dart';
import 'Linkpage.dart';
import 'MemoList.dart';
import 'PageList.dart';

//Here are general Variables
var usercode = Hive.box('user_setting').get('usercode') ?? '';
var name = Hive.box('user_info').get('id') ?? '';
var useremail = Hive.box('user_info').get('email') ?? '';
final linkspaceset = Get.put(linkspacesetting());
final uiset = Get.put(uisetting());
final draw = Get.put(navibool());
final notilist = Get.put(notishow());
final peopleadd = Get.put(PeopleAdd());
final scollection = Get.put(selectcollection());
FirebaseFirestore firestore = FirebaseFirestore.instance;
//Here are PageUI Variables
var pagename;
var spacename;
var type;
//Here are SpaceinUI Variables
var spacefamilyid;
var spacefamilytype;
var spacefamilyindex;
//Here are MYPage Variables
final List<Linkpage> listpinlink = [];
final List<NotiList> listcompanytousers = [];
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
String code = '';
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
