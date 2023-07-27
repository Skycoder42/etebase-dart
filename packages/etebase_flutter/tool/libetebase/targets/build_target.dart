import 'dart:io';

abstract base class BuildTarget {
  const BuildTarget();

  String get name;

  String get rustTarget;

  String get binaryName;

  String get buildTool => 'cargo';

  Map<String, String> get buildEnv => const {};

  List<String> get extraBuildArgs => const [];

  Future<void> fixupSources(Directory srcDir) => Future.value();

  Future<void> postBuild(Directory srcDir, File binary) => Future.value();
}
