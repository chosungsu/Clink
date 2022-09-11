import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future cancelNotification({required int id}) async {
    await _notifications.cancel(id);
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
      required DateTime scheduledate}) async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    _notifications.zonedSchedule(
      id!,
      title,
      body,
      _nextInstance(scheduledate),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void showDailyNotification(
      {int id = 1,
      String? title,
      String? body,
      required DateTime scheduledate}) async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstancedaily(scheduledate),
      await _notificationDetails(),
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            setAsGroupSummary: true,
            fullScreenIntent: true,
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true);
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
    );
  }
}
