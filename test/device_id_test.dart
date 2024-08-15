import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_local_storage/hive_local_storage.dart';
import 'package:jarvis_2/global/device_id.dart';

void main() {
  group('deviceIdTest', () {
    test('correctly handles "android"', () async {
      WidgetsFlutterBinding.ensureInitialized();
      Hive.init(Directory.current.path);
      await Hive.openBox(DeviceFields.deviceInformation);
      print('New device id: ${Device.getId()}');
    });
  });
}
