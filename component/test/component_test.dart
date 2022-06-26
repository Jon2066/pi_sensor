import 'package:flutter_test/flutter_test.dart';
import 'package:component/component.dart';
import 'package:component/component_platform_interface.dart';
import 'package:component/component_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockComponentPlatform
    with MockPlatformInterfaceMixin
    implements ComponentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ComponentPlatform initialPlatform = ComponentPlatform.instance;

  test('$MethodChannelComponent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelComponent>());
  });

  test('getPlatformVersion', () async {
    Component componentPlugin = Component();
    MockComponentPlatform fakePlatform = MockComponentPlatform();
    ComponentPlatform.instance = fakePlatform;

    expect(await componentPlugin.getPlatformVersion(), '42');
  });
}
