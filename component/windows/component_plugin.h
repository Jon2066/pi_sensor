#ifndef FLUTTER_PLUGIN_COMPONENT_PLUGIN_H_
#define FLUTTER_PLUGIN_COMPONENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace component {

class ComponentPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ComponentPlugin();

  virtual ~ComponentPlugin();

  // Disallow copy and assign.
  ComponentPlugin(const ComponentPlugin&) = delete;
  ComponentPlugin& operator=(const ComponentPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace component

#endif  // FLUTTER_PLUGIN_COMPONENT_PLUGIN_H_
