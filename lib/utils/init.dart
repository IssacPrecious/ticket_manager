import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_manager/main.dart';
import 'package:ticket_manager/utils/globals.dart';

/// Set of functions which are called before runApp() inside main() function.
class Initializer {
  /// Called before runApp() inside main() function, in order to initialize the app.
  ///
  /// [sharedPreferences] - Used to store and retrieve data from [SharedPreferences].
  ///
  /// [authProvider] - Used to refresh user data upon app startup.
  ///
  ///
  static Future<void> initializeApp({
    SharedPreferences? sharedPreferences,
  }) async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    GlobalVariables.sharedPreferences = sharedPreferences;
  }

  static Future<void> initializeFCM() async {
    log("FCM INITIALIZATION STARTED");

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
      throw 'Notification permission not granted';
    }

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      GlobalVariables.notificationChannel = const AndroidNotificationChannel(
        'danmark_high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description,
        importance: Importance.high,
      );

      GlobalVariables.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await GlobalVariables.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(GlobalVariables.notificationChannel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FirebaseMessaging.onMessage : ${jsonEncode(message.toMap())}");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        GlobalVariables.flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              GlobalVariables.notificationChannel.id,
              GlobalVariables.notificationChannel.name,
              icon: 'notification_icon',
              channelDescription: GlobalVariables.notificationChannel.description,
              // colorized: true,
              // color: Colors.transparent,
            ),
          ),
        );
      }
      try {
        if (notification != null) {
          log("notification.onMessage : ${notification.title}");
        }
      } catch (e) {
        log(e.toString());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published! : ${jsonEncode(message.toMap())}');
    });

    log("FCM INITIALIZATION COMPLETED :)");
  }
}
