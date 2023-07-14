import 'android.dart';
import 'build_platform.dart';
import 'build_target.dart';
import 'ios.dart';

abstract base class PlatformTargets {
  PlatformTargets._();

  static const android = AndroidPlatform();

  static const ios = IosPlatform();

  static const values = <BuildPlatform>[
    android,
    ios,
  ];

  static BuildTarget findTargetByName(String name) => values
      .expand((platform) => platform.targets)
      .singleWhere((target) => target.name == name);
}
