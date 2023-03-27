import 'package:get/get.dart';
import '../BACKENDPART/Getx/navibool.dart';

final navi = Get.put(navibool());

double mainTitleTextsize() {
  double ts = 0;
  navi.textsize == 0 ? ts = 25 : ts = 27;
  return ts;
}

double secondTitleTextsize() {
  double ts = 0;
  navi.textsize == 0 ? ts = 23 : ts = 25;
  return ts;
}

double contentTitleTextsize() {
  double ts = 0;
  navi.textsize == 0 ? ts = 20 : ts = 22;
  return ts;
}

double contentTextsize() {
  double ts = 0;
  navi.textsize == 0 ? ts = 18 : ts = 20;
  return ts;
}

double contentsmallTextsize() {
  double ts = 0;
  navi.textsize == 0 ? ts = 13 : ts = 15;
  return ts;
}
