import 'dart:io';

import 'build_target.dart';

abstract base class BuildPlatform<T extends BuildTarget> {
  const BuildPlatform();

  String get name;

  List<T> get targets;

  Future<void> createBundle(
    Directory bundleDir,
    Map<BuildTarget, File> binaries,
  ) =>
      createBundleImpl(bundleDir, binaries.cast());

  Future<void> createBundleImpl(Directory bundleDir, Map<T, File> binaries);
}
