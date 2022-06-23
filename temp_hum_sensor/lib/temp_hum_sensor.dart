import 'temp_hum_sensor_platform_interface.dart';

class TempHumSensor {
  Future<String?> getPlatformVersion() {
    return TempHumSensorPlatform.instance.getPlatformVersion();
  }

  Future<int?> setupSensor() {
    return TempHumSensorPlatform.instance.setupSensor();
  }

  Future<String?> read() {
    return TempHumSensorPlatform.instance.read();
  }
}
