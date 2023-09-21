

import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper{

   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

   NotificationsHelper(){
     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
   }
  int id = 0;


   Future<void> setupFlutterNotifications() async {
     // /// Update the iOS foreground notification presentation options to allow
     // /// heads up notifications.
     await FirebaseMessaging.instance.requestPermission(
       alert: true,
       announcement: true,
       badge: true,
       carPlay: false,
       criticalAlert: false,
       provisional: false,
       sound: true,
     );
     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
       alert: true,
       badge: true,
       sound: true,
     );
   }

  Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
    }
  }

  Future<void> showLocalNotification(RemoteMessage? remoteMessage) async{
     AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      '${Random().nextInt(1000)}', // Unique channel ID
      'desc${Random().nextInt(1000)}', // Channel name
      importance: Importance.high,
       sound: const RawResourceAndroidNotificationSound('alert'),
      playSound: true// Importance level (high, medium, low)
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);


    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        androidChannel.id,
        androidChannel.name,
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "@drawable/ic_task",
        sound: const RawResourceAndroidNotificationSound("alert"),
        //playSound: true
     );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('@drawable/ic_task');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
      },
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            break;
          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
    );
    await flutterLocalNotificationsPlugin.show(
        id++, remoteMessage?.notification?.title, remoteMessage?.notification?.body, notificationDetails,
        payload: 'item x');
  }
}