#import "EtebaseFlutterPlugin.h"
#if __has_include(<etebase_flutter/etebase_flutter-Swift.h>)
#import <etebase_flutter/etebase_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "etebase_flutter-Swift.h"
#endif

@implementation EtebaseFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEtebaseFlutterPlugin registerWithRegistrar:registrar];
}
@end
