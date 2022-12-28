#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint etebase_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'etebase_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Flutter extensions for the dart bindings of libetebase'
  s.description      = <<-DESC
Flutter extensions for the dart bindings of libetebase
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Skycoder42' => 'skycoder42@users.noreply.github.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  # s.vendored_libraries = 'Libraries/libetebase.dylib'
  s.vendored_frameworks = 'Libraries/libetebase.xcframework'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
