import 'dart:io';

abstract base class BuildTarget {
  const BuildTarget();

  String get name;

  String get rustTarget;

  bool get openSslVendored;

  String get binaryName;

  Map<String, String> get buildEnv => const {};

  List<String> get extraBuildArgs => const [];

  Future<void> fixupSources(Directory srcDir) => Future.value();
}
