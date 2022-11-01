import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/subjects.dart';

import '../Route/subuiroute.dart';
import '../UI/Home/firstContentNet/DayContentHome.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';

class NotificationApi {
  NotificationApi();
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  static Future cancelNotification({required int id}) async {
    await _notifications.cancel(id);
  }

  static Future cancelAll() async {
    await _notifications.cancelAll();
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');
    _notifications.show(id, title, body, await _notificationDetails());
  }

  static void showScheduledNotification(
      {int? id,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledate}) async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    _notifications.zonedSchedule(id!, title, body, _nextInstance(scheduledate),
        await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  static void showDailyNotification(
      {int id = 1,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledate}) async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    _notifications.zonedSchedule(id, title, body,
        _nextInstancedaily(scheduledate), await _notificationDetails(),
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  static void showDailyNotification_severalnotes(
      {int? id,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledate}) async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    _notifications.zonedSchedule(id!, title, body,
        _nextInstancedaily(scheduledate), await _notificationDetails(),
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  // 알림일자
  static tz.TZDateTime _nextInstance(DateTime scheduledate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledate.year,
      scheduledate.month,
      scheduledate.day,
      scheduledate.hour,
      scheduledate.minute,
    );
    //tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledate, tz.local);
    // 알람시간이 현재보다 이전인 경우 5초 뒤에 알람이 울린다.
    /*if (scheduledDate.isBefore(now)) {
      scheduledDate =
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    }*/

    return scheduledDate;
  }

  static tz.TZDateTime _nextInstancedaily(DateTime scheduledate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      scheduledate.hour,
      scheduledate.minute,
    );
    //tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledate, tz.local);
    // 알람시간이 현재보다 이전인 경우 5초 뒤에 알람이 울린다.
    return scheduledDate;
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', '캘린더와 메모알림',
            channelDescription: '캘린더와 메모 등의 푸쉬알림',
            setAsGroupSummary: true,
            fullScreenIntent: false,
            autoCancel: true,
            enableLights: true,
            sound: RawResourceAndroidNotificationSound('notification'),
            importance: Importance.max),
        iOS: IOSNotificationDetails(
            sound: 'notification.mp3',
            presentSound: true,
            presentAlert: true,
            presentBadge: true));
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true);
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(settings,
        onSelectNotification: onSelectNoti);
  }

  static void onSelectNoti(String? payload) async {
    print(payload);
    if (payload != null && payload.isNotEmpty) {
      if (payload.isNotEmpty) {
        if (payload == 'memo') {
          Get.to(
              () => const DayNoteHome(
                    title: '',
                    isfromwhere: 'home',
                  ),
              transition: Transition.downToUp);
        } else {
          Get.to(() => DayContentHome(id: payload),
              transition: Transition.downToUp);
        }
      } else {}
    }
  }

  static void runWhileAppIsTerminated(BuildContext context) async {
    var details = await _notifications.getNotificationAppLaunchDetails();

    if (details!.didNotificationLaunchApp) {
      if (details.payload != null) {
        if (details.payload == 'memo') {
          GoToMain(context);
          Future.delayed(const Duration(seconds: 1), () {
            Get.to(
                () => const DayNoteHome(
                      title: '',
                      isfromwhere: 'home',
                    ),
                transition: Transition.downToUp);
          });
        } else {
          GoToMain(context);
          Future.delayed(const Duration(seconds: 1), () {
            Get.to(() => DayContentHome(id: details.payload.toString()),
                transition: Transition.downToUp);
          });
        }
      } else {
        GoToMain(context);
      }
    } else {
      GoToMain(context);
    }
  }
}
