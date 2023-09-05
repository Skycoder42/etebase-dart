#include "include/etebase_flutter/etebase_flutter_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#define ETEBASE_FLUTTER_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), etebase_flutter_plugin_get_type(), \
                              EtebaseFlutterPlugin))

struct _EtebaseFlutterPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(EtebaseFlutterPlugin, etebase_flutter_plugin, g_object_get_type())

static void etebase_flutter_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(etebase_flutter_plugin_parent_class)->dispose(object);
}

static void etebase_flutter_plugin_class_init(EtebaseFlutterPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = etebase_flutter_plugin_dispose;
}

static void etebase_flutter_plugin_init(EtebaseFlutterPlugin* self) {}

void etebase_flutter_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  EtebaseFlutterPlugin* plugin = ETEBASE_FLUTTER_PLUGIN(
      g_object_new(etebase_flutter_plugin_get_type(), nullptr));
  g_object_unref(plugin);
}
