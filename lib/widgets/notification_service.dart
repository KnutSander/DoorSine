/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 03/03/2022

// Imports
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('Notification', 'Notification',
            importance: Importance.max));
  }

  static Future displayNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _notificationPlugin.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }
}
