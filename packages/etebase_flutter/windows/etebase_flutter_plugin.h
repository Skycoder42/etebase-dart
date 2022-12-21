#ifndef FLUTTER_PLUGIN_ETEBASE_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_ETEBASE_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace etebase_flutter {

class EtebaseFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EtebaseFlutterPlugin();

  virtual ~EtebaseFlutterPlugin();

  // Disallow copy and assign.
  EtebaseFlutterPlugin(const EtebaseFlutterPlugin&) = delete;
  EtebaseFlutterPlugin& operator=(const EtebaseFlutterPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace etebase_flutter

#endif  // FLUTTER_PLUGIN_ETEBASE_FLUTTER_PLUGIN_H_
