import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import '../../provider/user_provider.dart';
import '../../services/dialog.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
DialogService dialogService = locator<DialogService>();

class FirebaseUtils extends StatefulWidget {
  const FirebaseUtils({Key? key}) : super(key: key);

  static main() async {
    debugPrint("******************FIREBASE CONNECTION******************");

    try {
      getToken() async {
        final token = (await FirebaseMessaging.instance.getToken());
        debugPrint("********************MESSAGE GET TOKEN******************");
        debugPrint(token.toString());
        await UserProvider().setDeviceToken(token);
      }

      // FlutterAppBadger.updateBadgeCount(UserProvider().notification());
      getToken();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      if (!kIsWeb) {
        channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
        );

        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        debugPrint("+++++ +++++ +++++ON MESSAGE CHANGE+++++ +++++ +++++");
        debugPrint(message.data.toString());

        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        final IOSInitializationSettings initializationSettingsIOS =
            const IOSInitializationSettings();
        final MacOSInitializationSettings initializationSettingsMacOS =
            const MacOSInitializationSettings();
        final InitializationSettings initializationSettings =
            InitializationSettings(
                android: initializationSettingsAndroid,
                iOS: initializationSettingsIOS,
                macOS: initializationSettingsMacOS);
        await flutterLocalNotificationsPlugin
            .initialize(initializationSettings);

        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        String jsonAuthorStr = message.data["data"];
        Map<String, dynamic> temp = json.decode(jsonAuthorStr);

        // {data: {"navigation_object_type":"SWAP","navigation_object_id":"1bd0fdb0-3def-4b2d-b37a-da1a537401f4"}}
        debugPrint("*** *** *** *** *** *** *** *** *** *** *** *** ** ");
        debugPrint('A new onMessageOpenedApp event was published! $temp');
        debugPrint("*** *** *** *** *** *** *** *** *** *** *** *** *** ");
      });
    } catch (err) {
      debugPrint(
          "******************FIREBASE CONNECTION ERRROR******************");
      debugPrint(err.toString());
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
