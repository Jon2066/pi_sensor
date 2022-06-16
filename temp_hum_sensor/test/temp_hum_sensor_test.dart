import 'package:flutter_test/flutter_test.dart';
import 'package:temp_hum_sensor/temp_hum_sensor.dart';
import 'package:temp_hum_sensor/temp_hum_sensor_platform_interface.dart';
import 'package:temp_hum_sensor/temp_hum_sensor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTempHumSensorPlatform
    with MockPlatformInterfaceMixin
    implements TempHumSensorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TempHumSensorPlatform initialPlatform = TempHumSensorPlatform.instance;

  test('$MethodChannelTempHumSensor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTempHumSensor>());
  });

  test('getPlatformVersion', () async {
    TempHumSensor tempHumSensorPlugin = TempHumSensor();
    MockTempHumSensorPlatform fakePlatform = MockTempHumSensorPlatform();
    TempHumSensorPlatform.instance = fakePlatform;

    expect(await tempHumSensorPlugin.getPlatformVersion(), '42');
  });
}
