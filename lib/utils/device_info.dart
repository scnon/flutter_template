import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DeviceInfo {
  late bool isIOS;
  late bool isSim;
  late String id;
  late String name;
  late String model;
  late String os;
  late String osVer;

  DeviceInfo.unknow() {
    isSim = true;
    name = "Unknow";
    model = "Unknow";
    os = "Unknow";
    osVer = "Unknow";
  }

  DeviceInfo.fromIOS(IosDeviceInfo info) {
    isIOS = true;
    isSim = !info.isPhysicalDevice;
    id = info.identifierForVendor ?? const Uuid().v4();
    name = info.name;
    model = info.model;
    os = info.systemName;
    osVer = info.systemVersion;
  }

  DeviceInfo.formAndroid(AndroidDeviceInfo info) {
    isIOS = false;
    isSim = !info.isPhysicalDevice;
    model = info.model;
    name = info.device;
    id = const Uuid().v4();
    os = "Android";
    osVer = info.version.release;
  }

  @override
  String toString() {
    return """\n============== DeviceInfo ==============
Id:    $id
Name:  $name
Model: $model
OS:    $os
OSVer: $osVer
IsSim: $isSim
========================================""";
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "os": os, "osVer": osVer, "idefine": id};
  }
}
