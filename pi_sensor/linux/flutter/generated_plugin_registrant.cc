//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <temp_hum_sensor/temp_hum_sensor_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) temp_hum_sensor_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "TempHumSensorPlugin");
  temp_hum_sensor_plugin_register_with_registrar(temp_hum_sensor_registrar);
}
