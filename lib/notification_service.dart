/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 03/03/2022

// Imports
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Singleton objet for handling notifications
class NotificationService {
  // Static reference to itself
  static final NotificationService _notificationService =
      NotificationService._internal();

  // A factory constructor that doesn't create a new instance every call
  factory NotificationService(){
    return _notificationService;
  }

  // Cache constructor
  NotificationService._internal();
}