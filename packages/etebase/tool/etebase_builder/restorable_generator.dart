// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

abstract class RestorableGenerator extends Generator {
  final bool restoreMode;

  RestorableGenerator({required this.restoreMode});

  @override
  @nonVirtual
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    if (restoreMode) {
      return _restore(buildStep);
    } else {
      return generateImpl(library, buildStep);
    }
  }

  @protected
  String generateImpl(LibraryReader library, BuildStep buildStep);

  Future<String> _restore(BuildStep buildStep) async {
    final outPath = buildStep.allowedOutputs.single.path;
    print('Restoring $outPath from git');

    final result = await Process.run('git', ['restore', outPath]);
    if ((result.stderr as String).isNotEmpty) {
      print(result.stderr);
    }
    if (result.exitCode != 0) {
      throw Exception(
        'git restore $outPath failed with exit code: ${result.exitCode}',
      );
    }

    final file = File(outPath);
    try {
      return await file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .skipWhile((line) => !line.startsWith('// ignore_for_file:'))
          .join('\n');
    } finally {
      await file.delete();
    }
  }
}
