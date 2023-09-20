

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


   Future<void> InIt() async{
     AndroidInitializationSettings initializationSettingsAndroid =
     const AndroidInitializationSettings('@mipmap/ic_launcher');

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
       //onDidReceiveBackgroundNotificationResponse: (_){},
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

  Future<void> showNotification(RemoteMessage? remoteMessage) async{
    print("shaimaa: showNotification");

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

     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        androidChannel.id,
        androidChannel.name,
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        sound: const RawResourceAndroidNotificationSound('alert'),
        playSound: true
     );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  /***
   *
   *
   *
   ***/
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

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
      //onDidReceiveBackgroundNotificationResponse: (_){},
    );
    /**
     *
     *
     *
     */
    await flutterLocalNotificationsPlugin.show(
        id++, 'shaimaa', 'shaimaa---', notificationDetails,
        payload: 'item x');
  }
}