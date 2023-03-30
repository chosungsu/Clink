import 'package:get/get.dart';
import '../BACKENDPART/Getx/UserInfo.dart';

String datecheck(DateTime dateTime) {
  final info = Get.put(UserInfo());
  final currentDate = DateTime.now();
  final difference = currentDate.difference(dateTime).inDays;

  if (info.locale!.languageCode == 'en') {
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference day';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks weeks';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months months';
    } else {
      final years = (difference / 365).floor();
      return '$years years';
    }
  } else {
    if (difference == 0) {
      return '오늘';
    } else if (difference == 1) {
      return '어제';
    } else if (difference < 7) {
      return '$difference일 전';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks주 전';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months개월 전';
    } else {
      final years = (difference / 365).floor();
      return '$years년 전';
    }
  }
}
