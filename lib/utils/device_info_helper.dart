import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_manager/utils/globals.dart';

class AppDeviceInfo {
  static Future<String> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? deviceName;
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model!;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name!;
      }
      await preferences.setString(GlobalVariables.deviceName!, deviceName!);
      log('Device Name :: $deviceName');

      return deviceName;
    } on PlatformException {
      log('Failed to get Device Info Details');
      return Future.error('Failed to get Device Info Details');
    }
  }

  static Future<String> getDeviceUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String deviceUUID = '';
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo? build = await deviceInfoPlugin.androidInfo;
        if (build.id != null) {
          deviceUUID = build.id.toString();
        }
      } else if (Platform.isIOS) {
        IosDeviceInfo? data = await deviceInfoPlugin.iosInfo;
        if (data.identifierForVendor != null) {
          deviceUUID = data.identifierForVendor.toString();
        }
      }
      await preferences.setString(GlobalVariables.deviceId!, deviceUUID);

      log('Device UUID :: $deviceUUID');

      return deviceUUID;
    } on PlatformException {
      log('Failed to get Device Info Details');
      return Future.error('Failed to get Device Info Details');
    }
  }
}
