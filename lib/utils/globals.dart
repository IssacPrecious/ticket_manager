import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static SharedPreferences? sharedPreferences;
  static String? deviceName = "devicename";
  static String? deviceId = "deviceid";
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel notificationChannel;
}
