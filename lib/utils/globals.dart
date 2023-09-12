import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static SharedPreferences? sharedPreferences;
  static String? deviceName = "devicename";
  static String? deviceId = "deviceid";
  static int otpCountDownServer = 0;
  static OverlayEntry? profileMenuOverlayEntry;
  static bool isNotificationOpen = false;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel notificationChannel;
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static int drawpage = 0;
}
