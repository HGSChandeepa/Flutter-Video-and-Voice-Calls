// Dart imports:
import 'dart:convert';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

// The purpose of this function is to create a short, unique, numeric user ID based on the device's unique identifier. This is useful for identifying users in an app without requiring explicit user account registration. By shortening the ID and removing non-numeric characters, the function ensures the generated ID is consistent across devices but remains anonymous and relatively easy to store.

Future<String> getUniqueUserId() async {
  String? deviceID;
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    final iosDeviceInfo = await deviceInfo.iosInfo;
    deviceID = iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    final androidDeviceInfo = await deviceInfo.androidInfo;
    deviceID = androidDeviceInfo.id; // unique ID on Android
  }

  if (deviceID != null && deviceID.length < 4) {
    if (Platform.isAndroid) {
      deviceID += '_android';
    } else if (Platform.isIOS) {
      deviceID += '_ios___';
    }
  }
  if (Platform.isAndroid) {
    deviceID ??= 'flutter_user_id_android';
  } else if (Platform.isIOS) {
    deviceID ??= 'flutter_user_id_ios';
  }

  final userID = md5
      .convert(utf8.encode(deviceID!))
      .toString()
      .replaceAll(RegExp(r'[^0-9]'), '');

  //get the last 6 chars of the userID
  return userID.substring(userID.length - 6);
}
