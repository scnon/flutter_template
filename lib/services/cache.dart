import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/utils/logger.dart';
import '/utils/device_info.dart';

const String _keyChainId = 'KEYCHAIN_UUID';

class CacheService extends GetxService {
  // 工厂函数单例
  CacheService._internal();
  factory CacheService() => _instance;
  static final CacheService _instance = CacheService._internal();

  late SharedPreferences _preferences;
  late FlutterSecureStorage _secureStorage;

  late final PackageInfo _appInfo;
  late final IosDeviceInfo _iosInfo;
  late final DeviceInfo _deviceInfo;
  late final AndroidDeviceInfo _androidInfo;

  PackageInfo get appInfo => _appInfo;
  DeviceInfo get deviceInfo => _deviceInfo;
  IosDeviceInfo get iosInfo => _iosInfo;
  AndroidDeviceInfo get androidInfo => _androidInfo;

  Future<CacheService> init() async {
    _secureStorage = const FlutterSecureStorage();
    _preferences = await SharedPreferences.getInstance();

    _deviceInfo = await getDeviceInfo();
    _appInfo = await PackageInfo.fromPlatform();

    Logger.d(_deviceInfo);
    return this;
  }

  Future<DeviceInfo> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      _iosInfo = await deviceInfo.iosInfo;
      var info = DeviceInfo.fromIOS(_iosInfo);
      var uuid = await getSecureString(_keyChainId);
      if (uuid == null) {
        Logger.d("uuid is new ${info.id}");
        setSecureString(_keyChainId, info.id);
      } else {
        info.id = uuid;
        Logger.d("uuid is load from device $uuid");
      }
      return info;
    } else if (Platform.isAndroid) {
      _androidInfo = await deviceInfo.androidInfo;
      var info = DeviceInfo.formAndroid(_androidInfo);
      var uuid = await getSecureString(_keyChainId);
      if (uuid == null) {
        info.id = await const AndroidId().getId() ?? info.id;
        setSecureString(_keyChainId, info.id);
      }
      return info;
    } else {
      return DeviceInfo.unknow();
    }
  }

  // Base Storage
  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> setBool(String key, bool val) {
    return _preferences.setBool(key, val);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  // Secure Storage
  Future setSecureJSON(String key, dynamic jsonVal) async {
    String jsonString = jsonEncode(jsonVal);
    await setSecureString(key, jsonString);
  }

  dynamic getSecureJSON(String key) async {
    String? jsonString = await getSecureString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return _secureStorage.read(key: key);
  }

  Future removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }
}
