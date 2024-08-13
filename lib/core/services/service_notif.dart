import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/core/services/_services.dart';

class NotificationService {
  const NotificationService._();

  static Future<void> development() {
    return _initializeNotifications();
  }

  static Future<void> production() {
    return _initializeNotifications();
  }

  static FlutterLocalNotificationsPlugin? _localNotifications;
  static FlutterLocalNotificationsPlugin get localNotifications => _localNotifications!;

  static Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    final notificationsPlugin = FlutterLocalNotificationsPlugin();
    await notificationsPlugin.initialize(initializationSettings);

    _localNotifications = notificationsPlugin;
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    bool fixed = false,
    DateTime? dateTime,
    int id = 0,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      "availability_id",
      "user's Availability",
      channelDescription: "Notification to show user's Availability",
      importance: Importance.max,
      priority: Priority.high,
      channelShowBadge: true,
      autoCancel: false,
      ongoing: fixed,
    );
    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    if (dateTime != null) {
      if (DateTime.now().isBefore(dateTime) || (HiveConfig.notifications != null && HiveConfig.notifications!)) return;

      final zone = await FlutterTimezone.getLocalTimezone();
      final scheduledDate = tz.TZDateTime.from(dateTime, tz.getLocation(zone));
      return localNotifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    await cancelNotification();

    return localNotifications.show(0, title, body, notificationDetails);
  }

  static Future<void> cancelNotification({
    int? id,
  }) {
    if (id != null) {
      return localNotifications.cancel(id);
    }
    return localNotifications.cancelAll();
  }
}
