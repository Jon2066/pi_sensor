import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'component_method_channel.dart';

abstract class ComponentPlatform extends PlatformInterface {
  /// Constructs a ComponentPlatform.
  ComponentPlatform() : super(token: _token);

  static final Object _token = Object();

  static ComponentPlatform _instance = MethodChannelComponent();

  /// The default instance of [ComponentPlatform] to use.
  ///
  /// Defaults to [MethodChannelComponent].
  static ComponentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ComponentPlatform] when
  /// they register themselves.
  static set instance(ComponentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> setup() {
    throw UnimplementedError('setup() has not been implemented.');
  }
  
  Future<int?> setRGBLED(int rgb) {
    throw UnimplementedError('setRGBLED() has not been implemented.');
  }

}
