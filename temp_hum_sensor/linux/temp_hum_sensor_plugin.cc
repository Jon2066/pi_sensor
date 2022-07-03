#include "include/temp_hum_sensor/temp_hum_sensor_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <wiringPi.h>

#define TEMP_HUM_GPIO 7

#define TEMP_HUM_SENSOR_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), temp_hum_sensor_plugin_get_type(), \
                              TempHumSensorPlugin))

struct _TempHumSensorPlugin
{
  GObject parent_instance;
};

G_DEFINE_TYPE(TempHumSensorPlugin, temp_hum_sensor_plugin, g_object_get_type())

static void DHT_setGPIO()
{
  pinMode(TEMP_HUM_GPIO, OUTPUT);
  digitalWrite(TEMP_HUM_GPIO, 0);
  delay(20);
  digitalWrite(TEMP_HUM_GPIO, 1);
  pinMode(TEMP_HUM_GPIO, INPUT);
}

static int DHT_check()
{
  while (!digitalRead(TEMP_HUM_GPIO))
  {
    continue;
  }
  while (digitalRead(TEMP_HUM_GPIO))
  {
    continue;
  }
  return 1;
}

static unsigned long DHT_readBit()
{
  int k = 0;
  while (!digitalRead(TEMP_HUM_GPIO))
  {
    continue;
  }
  while (digitalRead(TEMP_HUM_GPIO))
  {
    k += 1;
    if (k > 80)
    {
      return 1;
    }
    continue;
  }
  if(k >= 8){
    return 1;
  }
  return 0;
}

// Called when a method call is received from Flutter.
static void temp_hum_sensor_plugin_handle_method_call(
    TempHumSensorPlugin *self,
    FlMethodCall *method_call)
{
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar *method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0)
  {
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
        pinMode(TEMP_HUM_GPIO, OUTPUT);
        digitalWrite(TEMP_HUM_GPIO, 1);
        delay(1000);
      g_autoptr(FlValue) result = fl_value_new_int(0);

      response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    }
  }
  else if (strcmp(method, "read") == 0)
  {
    DHT_setGPIO();
    if (DHT_check())
    {
      unsigned long data = 0;
      unsigned int check = 0;
      for (int i = 0; i < 32; i++)
      {
        data += DHT_readBit() << (31 - i);
      }
      for (int i = 0; i < 8; i++)
      {
        check += DHT_readBit() << (7 - i);
      }
      unsigned int dataCheck = ((data >> 24) & 0xff + (data >> 16) & 0xff + (data >> 8) & 0xff + data & 0xff) & 0xff;
      if (check == dataCheck)
      {
        g_autofree gchar *value = g_strdup_printf("%lu", data);
        g_autoptr(FlValue) result = fl_value_new_string(value);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
      }
      else
      {
        g_autofree gchar *value = g_strdup_printf("%lu", (unsigned long)0);
        g_autoptr(FlValue) result = fl_value_new_string(value);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
      }
    }
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void temp_hum_sensor_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(temp_hum_sensor_plugin_parent_class)->dispose(object);
}

static void temp_hum_sensor_plugin_class_init(TempHumSensorPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = temp_hum_sensor_plugin_dispose;
}

static void temp_hum_sensor_plugin_init(TempHumSensorPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  TempHumSensorPlugin *plugin = TEMP_HUM_SENSOR_PLUGIN(user_data);
  temp_hum_sensor_plugin_handle_method_call(plugin, method_call);
}

void temp_hum_sensor_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  TempHumSensorPlugin *plugin = TEMP_HUM_SENSOR_PLUGIN(
      g_object_new(temp_hum_sensor_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "temp_hum_sensor",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
