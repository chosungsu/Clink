// ignore_for_file: non_constant_identifier_names

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  NotificationApi();
  static final _notifications = FlutterLocalNotificationsPlugin();

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
        android: AndroidNotificationDetails(
            'channel id', '캘린더와 메모알림', '캘린더와 메모 등의 푸쉬알림',
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
      requestBadgePermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
    );
  }

  /*static void onSelectNoti(NotificationResponse? response) async {
    if (response!.payload != null && response.payload!.isNotEmpty) {
      if (response.payload!.isNotEmpty) {
        if (response.payload! == 'memo') {
          Get.to(
              () => const DayNoteHome(
                    title: '',
                    isfromwhere: 'home',
                  ),
              transition: Transition.downToUp);
        } else {
          Get.to(() => DayContentHome(response.payload!),
              transition: Transition.downToUp);
        }
      } else {}
    }
  }

  static void runWhileAppIsTerminated() async {
    var details = await _notifications.getNotificationAppLaunchDetails();
    try {
      if (details!.didNotificationLaunchApp) {
        if (details.notificationResponse!.payload != null) {
          if (details.notificationResponse!.payload == 'memo') {
            GoToMain();
            Future.delayed(const Duration(seconds: 1), () {
              Get.to(
                  () => const DayNoteHome(
                        title: '',
                        isfromwhere: 'home',
                      ),
                  transition: Transition.downToUp);
            });
          } else {
            GoToMain();
            Future.delayed(const Duration(seconds: 1), () {
              Get.to(
                  () => DayContentHome(
                      details.notificationResponse!.payload.toString()),
                  transition: Transition.downToUp);
            });
          }
        } else {
          GoToMain();
        }
      } else {
        GoToMain();
      }
    } catch (e) {
      GoToMain();
    }
  }*/
}
