#include "etebase_flutter_plugin.h"

#include <flutter/plugin_registrar_windows.h>

namespace etebase_flutter {

// static
void EtebaseFlutterPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto plugin = std::make_unique<EtebaseFlutterPlugin>();
  registrar->AddPlugin(std::move(plugin));
}

EtebaseFlutterPlugin::EtebaseFlutterPlugin() {}

EtebaseFlutterPlugin::~EtebaseFlutterPlugin() {}

}  // namespace etebase_flutter
