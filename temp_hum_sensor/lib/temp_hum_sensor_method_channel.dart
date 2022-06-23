import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'temp_hum_sensor_platform_interface.dart';

/// An implementation of [TempHumSensorPlatform] that uses method channels.
class MethodChannelTempHumSensor extends TempHumSensorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('temp_hum_sensor');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> setupSensor() async {
    final status = await methodChannel.invokeMethod<int>('setup');
    return status;
  }

  @override
  Future<String?> read() async {
    final value = await methodChannel.invokeMethod<String>('read');
    return value;
  }
}
