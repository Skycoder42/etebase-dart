#include "include/etebase_flutter/etebase_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "etebase_flutter_plugin.h"

void EtebaseFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  etebase_flutter::EtebaseFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
