import 'dart:io';

import 'package:hive_local_storage/hive_local_storage.dart';

class DeviceFields {
  static const String deviceInformation = 'deviceInformation';
  static const String deviceId = 'deviceId';
}

class Device {
  static String deviceId = '';

  static String getId() {
    if (Device.deviceId.isEmpty) {
      return Device.deviceId;
    }

    print('opening box');
    final box = Hive.box(DeviceFields.deviceInformation);
    print('box opened');

    Device.deviceId = box.get(DeviceFields.deviceId);

    if (Device.deviceId.isEmpty) {
      Device.deviceId = '';
      if (Platform.isAndroid) {
        Device.deviceId = 'android';
      } else if (Platform.isIOS) {
        Device.deviceId = 'ios';
      } else {
        Device.deviceId = 'web';
      }

      Device.deviceId += DateTime.now().toString();
      print('New device id: ${Device.deviceId}');
      box.put(DeviceFields.deviceId, Device.deviceId);
    }

    return Device.deviceId;
  }
}
