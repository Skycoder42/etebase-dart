#ifndef FLUTTER_PLUGIN_ETEBASE_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_ETEBASE_FLUTTER_PLUGIN_H_

#include <flutter/plugin_registrar_windows.h>

namespace etebase_flutter {

class EtebaseFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EtebaseFlutterPlugin();

  virtual ~EtebaseFlutterPlugin();

  // Disallow copy and assign.
  EtebaseFlutterPlugin(const EtebaseFlutterPlugin&) = delete;
  EtebaseFlutterPlugin& operator=(const EtebaseFlutterPlugin&) = delete;
};

}  // namespace etebase_flutter

#endif  // FLUTTER_PLUGIN_ETEBASE_FLUTTER_PLUGIN_H_
