import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static Future<String> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor ??'';
    } else if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      return deviceInfo.id;
    }
    return '';
  }
}
