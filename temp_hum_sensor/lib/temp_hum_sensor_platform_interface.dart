import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'temp_hum_sensor_method_channel.dart';

abstract class TempHumSensorPlatform extends PlatformInterface {
  /// Constructs a TempHumSensorPlatform.
  TempHumSensorPlatform() : super(token: _token);

  static final Object _token = Object();

  static TempHumSensorPlatform _instance = MethodChannelTempHumSensor();

  /// The default instance of [TempHumSensorPlatform] to use.
  ///
  /// Defaults to [MethodChannelTempHumSensor].
  static TempHumSensorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TempHumSensorPlatform] when
  /// they register themselves.
  static set instance(TempHumSensorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> setupSensor() {
    throw UnimplementedError('setupSensor() has not been implemented.');
  }

  Future<String?> read() {
    throw UnimplementedError('read() has not been implemented.');
  }
}
