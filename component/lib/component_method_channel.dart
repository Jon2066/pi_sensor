import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'component_platform_interface.dart';

/// An implementation of [ComponentPlatform] that uses method channels.
class MethodChannelComponent extends ComponentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('component');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> setup() async {
    final status = await methodChannel.invokeMethod<int>('setup');
    return status;
  }

  @override
  Future<int?> setRGBLED(int rgb) async {
    final status = await methodChannel.invokeMethod<int>('setRGBLED', {"rgb":rgb});
    return status;
  }

  @override
  Future<int?> reset() async {
    final status = await methodChannel.invokeMethod<int>('reset');
    return status;
  }
  
}
