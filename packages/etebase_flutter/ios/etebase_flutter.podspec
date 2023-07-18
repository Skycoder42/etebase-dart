#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint etebase_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'etebase_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Flutter platform plugins for the dart bindings of libetebase'
  s.description      = <<-DESC
Flutter platform plugins for the dart bindings of libetebase
                       DESC
  s.homepage         = 'https://github.com/Skycoder42/etebase-dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Skycoder42' => 'skycoder42@users.noreply.github.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'

  s.platform = :ios, '11.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # libetebase
  s.vendored_frameworks = "Libraries/libetebase.xcframework"
  s.xcconfig = {
    'OTHER_LDFLAGS[sdk=iphoneos*]' => '$(inherited) -force_load "$(PODS_ROOT)/../.symlinks/plugins/etebase_flutter/ios/Libraries/libetebase.xcframework/ios-arm64/libetebase.a"',
    'OTHER_LDFLAGS[sdk=iphonesimulator*]' => '$(inherited) -force_load "$(PODS_ROOT)/../.symlinks/plugins/etebase_flutter/ios/Libraries/libetebase.xcframework/ios-arm64_x86_64-simulator/libetebase.a"',
  }
end
