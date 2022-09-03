import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    _notifications.show(id, title, body, await _notificationDetails());
  }

  static void showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      required DateTime scheduledate}) async {
    _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledate, tz.local),
        await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
    );
  }
}
