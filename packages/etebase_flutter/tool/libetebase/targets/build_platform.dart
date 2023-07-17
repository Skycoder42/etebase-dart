import 'dart:io';

import 'build_target.dart';

abstract base class BuildPlatform<T extends BuildTarget> {
  const BuildPlatform();

  String get name;

  List<T> get targets;

  Future<void> createBundle(
    Directory bundleDir,
    String version,
    Map<BuildTarget, File> binaries,
  ) =>
      createBundleImpl(bundleDir, version, binaries.cast());

  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<T, File> binaries,
  );
}