//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <component/component_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) component_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ComponentPlugin");
  component_plugin_register_with_registrar(component_registrar);
}
