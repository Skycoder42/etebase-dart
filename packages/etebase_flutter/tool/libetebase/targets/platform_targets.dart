import 'android.dart';
import 'build_platform.dart';
import 'build_target.dart';
import 'ios.dart';
import 'linux.dart';
import 'macos.dart';
import 'windows.dart';

abstract base class PlatformTargets {
  PlatformTargets._();

  static const android = AndroidPlatform();

  static const ios = IosPlatform();

  static const linux = LinuxPlatform();

  static const macos = MacosPlatform();

  static const windows = WindowsPlatform();

  static const values = <BuildPlatform>[
    android,
    ios,
    linux,
    macos,
    windows,
  ];

  static BuildTarget findTargetByName(String name) => values
      .expand((platform) => platform.targets)
      .singleWhere((target) => target.name == name);
}
