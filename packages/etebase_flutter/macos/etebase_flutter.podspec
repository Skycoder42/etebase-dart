#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint etebase_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'etebase_flutter'
  s.version          = '1.1.1'
  s.summary          = 'Flutter platform plugins for the dart bindings of libetebase'
  s.description      = <<-DESC
Flutter platform plugins for the dart bindings of libetebase
                       DESC
  s.homepage         = 'https://github.com/Skycoder42/etebase-dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Skycoder42' => 'skycoder42@users.noreply.github.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'

  # libetebase
  s.vendored_libraries = 'Libraries/libetebase.dylib'
end
