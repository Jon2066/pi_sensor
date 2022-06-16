
import 'temp_hum_sensor_platform_interface.dart';

class TempHumSensor {
  Future<String?> getPlatformVersion() {
    return TempHumSensorPlatform.instance.getPlatformVersion();
  }
}
