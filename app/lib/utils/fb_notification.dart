import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/chat/chat.dart';
import 'package:sampleflutterproject/module/support_chat/support_chat.dart';
import '../model/info_payload_model.dart';

//perform on click
void selectNotification(NotificationResponse response) async {
  if (response.payload != null && response.payload!.isNotEmpty) {
    var res = json.decode(response.payload!)["is_customer_care"];
    logger.wtf(res, 'selectNotification');
    print('selectNotification');
    if (int.tryParse(res) == 1) {
      //Get.to(() => SupportChat());
      Get.to(
        () => Chat(chatType: ChatType.support),
        arguments: {
          "docId": app.userModel().id.toString(),
          "user[0]": app.userModel().id,
          "user[1]": 0,
          "displayName": "Customer Care",
          "userProfileUrl":
              "https://www.kindpng.com/picc/m/154-1540620_customer-care-customer-support-icon-transparent-hd-png.png",
        },
      );
    } else {
      InfoModel infoModel =
          infoModelFromJson(jsonDecode(response.payload!)["info"]);

      Get.to(
        () => Chat(),
        arguments: {
          "user[0]": infoModel.user0,
          "user[1]": infoModel.user1,
          "displayName": infoModel.displayName,
          "userProfileUrl": infoModel.userProfileUrl,
        },
      );
    }
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static fcmInit() async {
    try {
      print("in fcmInit");

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBg);

      var android =
          const AndroidNotificationDetails('sampleflutterproject', 'sampleflutterproject_description',
              //'channel_desc',
              priority: Priority.high,
              importance: Importance.max);

      var platform = NotificationDetails(android: android, iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),);

      const InitializationSettings settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
      );
      await flutterLocalNotificationsPlugin.initialize(
        settings,
        onDidReceiveBackgroundNotificationResponse: selectNotification,
        onDidReceiveNotificationResponse: selectNotification,
      );
      if (LocalStorageService.isFirst != null) {
        notificationsPlugin.show(0, "Welcome To sampleflutterproject",
            "Take A Loan Give A Loan", platform);
        LocalStorageService.setIsFirstTime(value: "j");
      }

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      //when app is close and perform onclick
      await FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? remoteMessage) async {
        try {
          if (remoteMessage != null && remoteMessage.data != null) {
            var msg = remoteMessage.data;
            var res = json.decode(msg["is_customer_care"]);
            print('getInitialMessage');
            if (int.tryParse(res.toString()) == 1) {
              //Get.to(() => SupportChat());
              Get.to(
                () => Chat(chatType: ChatType.support),
                arguments: {
                  "docId": app.userModel().id.toString(),
                  "user[0]": app.userModel().id,
                  "user[1]": 0,
                  "displayName": "Customer Care",
                  "userProfileUrl":
                      "https://www.kindpng.com/picc/m/154-1540620_customer-care-customer-support-icon-transparent-hd-png.png",
                },
              );
            } else {
              InfoModel infoModel = infoModelFromJson(msg["info"]);

              Get.to(
                () => Chat(),
                arguments: {
                  "user[0]": infoModel.user0,
                  "user[1]": infoModel.user1,
                  "displayName": infoModel.displayName,
                  "userProfileUrl": infoModel.userProfileUrl,
                },
              );
            }
          }
        } on Exception catch (e, t) {
          // TODO
          print("catch $e,\n$t");
        }
      });

      //when app is open and perform onclick
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (Platform.isIOS) {
        } else if (Platform.isAndroid) {
          try {
            var msg = message.data;
            if (message.notification != null) {
              print('onMessage');
              logger.wtf(message.notification, 'onMessage');
              await notificationsPlugin.show(
                Random().nextInt(11234567),
                message.notification!.title,
                message.notification!.body,
                platform,
                payload: json.encode(msg),
              );
            }
          } catch (e) {
            logger.e(e);
          }
        }
      });

      //when app is open in background
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        try {
          var msg = message.data;
          var res = json.decode(msg["is_customer_care"]);
          print('onMessageOpenedApp');
          logger.wtf(res, 'onMessageOpenedApp');
          if (int.tryParse(res.toString()) == 1) {
            //Get.to(() => SupportChat());
            Get.to(
              () => Chat(chatType: ChatType.support),
              arguments: {
                "docId": app.userModel().id.toString(),
                "user[0]": app.userModel().id,
                "user[1]": 0,
                "displayName": "Customer Care",
                "userProfileUrl":
                    "https://www.kindpng.com/picc/m/154-1540620_customer-care-customer-support-icon-transparent-hd-png.png",
              },
            );
          } else {
            InfoModel infoModel = infoModelFromJson(msg["info"]);

            Get.to(
              () => Chat(),
              arguments: {
                "user[0]": infoModel.user0,
                "user[1]": infoModel.user1,
                "displayName": infoModel.displayName,
                "userProfileUrl": infoModel.userProfileUrl,
              },
            );
          }
        } catch (e) {
          logger.e(e);
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }
}

@pragma('vm:entry-point') // this line for get background notification
Future<void> _firebaseMessagingBg(RemoteMessage message) async {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  // final FlutterLocalNotificationsPlugin notificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  // var android = const AndroidNotificationDetails('channel id', 'FCM',
  //     //'channel_desc',
  //     priority: Priority.high,
  //     importance: Importance.max);
  // var iOS = const DarwinNotificationDetails(presentSound: true);
  // var platform = NotificationDetails(android: android, iOS: iOS);
  // var msg = message.data;
  // await notificationsPlugin.show(
  //   Random().nextInt(11234567),
  //   message.notification!.title,
  //   message.notification!.body,
  //   platform,
  //   payload: json.encode(msg),
  // );
  print('Notification Message: ${message.data}');
}
