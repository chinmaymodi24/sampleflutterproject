import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:core/service/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../backend/notification_service.dart';
import '../styles/app_themes.dart';

class NotificationServices {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  static DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  static DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails();

  static final InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    icon: '@mipmap/ic_notification_icon',
  );
  static NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iosNotificationDetails,
  );

  static Future<void> iOSNotificationRequest() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initNotification() async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse details) {},
      onDidReceiveNotificationResponse: (NotificationResponse details) {},
    );
    await iOSNotificationRequest();
    NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.notificationResponse != null) {
      /// when app is close
    }
  }

  static Future<void> removeNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> scheduleNotifications({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String payload,
  }) async {
    try {
      var time = tz.TZDateTime.from(scheduledTime, tz.local);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        time,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e, t) {
      logger.e('Error :$e \n Trace :$t');
    }
  }

  static Future<void> initFirebaseMessaging() async {
    try {
      tz.initializeTimeZones();
      await initNotification();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        try {
          log("INCOMING MESSAGE NOTIFICATION DATA:${json.encode(message.data)}");
          var msg = message.data;
          if (message.notification != null) {
            showNotification(
              title: message.notification!.title!,
              body: message.notification!.body!,
              id: 1,
              // payload: message.data,
            );
          }
        } catch (e) {
          log("$e");
        }
      });

      await FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? remoteMessage) async {
             logger.i('NOTIFICATION GET FROM GETINITIALMESSAGE');

        if (remoteMessage != null && remoteMessage.data != null) {
          showNotification(
            title: remoteMessage.notification!.title!,
            body: remoteMessage.notification!.body!,
            id: 1,
            // payload: message.data,
          );        }
      });


      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          log('NOTIFICATION GET :${message.toMap()}');
          showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            id: 1,
            // payload: message.data,
          );
        },
      );
    } catch (e) {
      log('Notification Error  :${e}');
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e, t) {
      logger.e('Error :$e \n Trace :$t');
    }
  }

  static Future<void> updateFCM() async {
    var deviceId = await DeviceInfo.getDeviceId();
    String fcmToken = await messaging.getToken() ?? '';
    if (deviceId.isNotEmpty && fcmToken.isNotEmpty) {
      await NotificationAPIService.updateFCMToken(
          {'fcmToken': fcmToken, 'deviceId': deviceId});
    }
  }
}



  // FirebaseMessaging.onMessageOpenedApp
  //     .listen((RemoteMessage message) async {
  //   try {
  //     var msg = message.data;
  //     var chatroom = json.decode(msg["chats"]);
  //     logger.wtf(chatroom);
  //     Get.to(() => Messages(
  //       chatroomID: chatroom,
  //     ));
  //   } catch (e) {
  //     logger.e(e);
  //   }
  // });
