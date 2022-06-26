#include "include/component/component_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "component_plugin.h"

void ComponentPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  component::ComponentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
