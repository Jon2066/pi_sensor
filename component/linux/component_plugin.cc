#include "include/component/component_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <wiringPi.h>
#include <softPwm.h>

#define RGB_R_GPIO 27
#define RGB_G_GPIO 28
#define RGB_B_GPIO 29


#define COMPONENT_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), component_plugin_get_type(), \
                              ComponentPlugin))

struct _ComponentPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(ComponentPlugin, component_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void component_plugin_handle_method_call(
    ComponentPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data = {};
    uname(&uname_data);
    g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  }
  else if (strcmp(method, "setup") == 0)
  {
    if (wiringPiSetup() == -1)
    {
      g_autoptr(FlValue) result = fl_value_new_int(1);

      response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    }
    else
    {
	    softPwmCreate(RGB_R_GPIO,  0, 100);
	    softPwmCreate(RGB_G_GPIO,  0, 100);
	    softPwmCreate(RGB_B_GPIO,  0, 100);

      g_autoptr(FlValue) result = fl_value_new_int(0);

      response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    }
  }
  else if (strcmp(method, "setRGBLED") == 0) {
    auto *args = fl_method_call_get_args(method_call);
    unsigned int rgb = fl_value_get_int(fl_value_lookup_string(args, "rgb"));
    unsigned char r = (rgb >> 24) & 0xff;
    unsigned char g = (rgb >> 16) & 0xff;
    unsigned char b = rgb & 0xff;
    softPwmWrite(RGB_R_GPIO, (int)(100 * r / 255.0));
    softPwmWrite(RGB_G_GPIO, (int)(100 * g / 255.0));
    softPwmWrite(RGB_B_GPIO, (int)(100 * b / 255.0));
  }
   else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void component_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(component_plugin_parent_class)->dispose(object);
}

static void component_plugin_class_init(ComponentPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = component_plugin_dispose;
}

static void component_plugin_init(ComponentPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  ComponentPlugin* plugin = COMPONENT_PLUGIN(user_data);
  component_plugin_handle_method_call(plugin, method_call);
}

void component_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  ComponentPlugin* plugin = COMPONENT_PLUGIN(
      g_object_new(component_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "component",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
