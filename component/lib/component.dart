
import 'component_platform_interface.dart';

class Component {
  Future<String?> getPlatformVersion() {
    return ComponentPlatform.instance.getPlatformVersion();
  }

  Future<int?> setRGBLED(int rgb) {
    return ComponentPlatform.instance.setRGBLED(rgb);
  }
  
  Future<int?> setup() {
    return ComponentPlatform.instance.setup();
  }
}
