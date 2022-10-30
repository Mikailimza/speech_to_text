

import 'package:device_info_plus/device_info_plus.dart';

//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com 
final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'dvtp': 'android',
    'dvid': build.id,
    'dvbr': build.manufacturer,
    'dvmd': build.model,
    'dvos': build.version.release,
    'dvph': build.isPhysicalDevice.toString(),
  };
}

Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'dvtp': 'ios',
    'dvid': data.identifierForVendor,
    'dvbr': 'Apple',
    'dvmd': data.model,
    'dvos': data.systemVersion,
    'dvph': data.isPhysicalDevice.toString(),
  };
}