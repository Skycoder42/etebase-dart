import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:etebase/src/impl/codec/base64_url_no_pad_codec.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import 'js_client_wrapper_stub.dart' as stub;
import 'library_loader.dart';

@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject object);

class JsClientWrapper extends stub.JsClientWrapper {
  static const _etebaseJsPath = 'node_modules/etebase/dist/umd/Etebase.js';
  static const _runJsPath = 'dist/util/run.js';
  static const _testUtilsJsPath = 'dist/util/test.js';
  static const _vmCode = r'''
import 'dart:io';

import 'package:stream_channel/stream_channel.dart';

Future<void> hybridMain(StreamChannel channel, Object? message) async {
  final jsBundleFile = File('tool/js_client/$message');
  final jsBundle = await jsBundleFile.readAsString();
  channel.sink.add(jsBundle);
}
''';

  JsClientWrapper() : super.base();

  @override
  Future<TRes> executeSignedIn<TRes>(
    stub.Action action, {
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) async => await execute<TRes>(
    action,
    actionExtra: {'savedAccountData': await account.save()},
    fromJson: fromJson,
  );

  @override
  Future<TRes> executeForCollection<TRes>(
    stub.Action action, {
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) async => await execute<TRes>(
    action,
    actionExtra: {
      'savedAccountData': await account.save(),
      'colUid': collection.uid,
    },
    fromJson: fromJson,
  );

  static Future<TRes> execute<TRes>(
    stub.Action action, {
    bool useDefaultServer = false,
    Map<String, dynamic>? actionExtra,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) async {
    final exports = _getExports();
    final etebase = await _loadEtebase(exports);
    final testUtils = await _loadTestUtils(exports);
    final run = await _loadRun(exports);

    await _loadJs(action.$type, 'dist/actions/${action.$type}.js');
    final actionConfig = exports['${action.$type}Config']! as JSObject;

    final rawAction = action.toJson();
    if (!useDefaultServer) {
      rawAction['serverUrl'] = serverUri.toString();
    }
    if (actionExtra != null) {
      rawAction.addAll(actionExtra);
    }

    printOnFailure('EXECUTING: $action');
    final result = run.callAsFunction(
      globalContext,
      etebase,
      testUtils,
      rawAction.jsify(),
      actionConfig,
    );
    final awaitedResult = await (result as JSPromise?)?.toDart;
    printOnFailure('>> RESULT: ${awaitedResult.runtimeType}');
    if (awaitedResult.isA<JSArray<JSString>>()) {
      final arr = awaitedResult! as JSArray<JSString>;
      return arr.toDart.cast<String>() as TRes;
    } else if (TRes == Uint8List) {
      return base64UrlNoPad.decode(awaitedResult.dartify()! as String) as TRes;
    } else {
      return awaitedResult.dartify() as TRes;
    }
  }

  static JSObject _getExports() {
    if (!globalContext.has('exports')) {
      globalContext['exports'] = JSObject();
    }
    return globalContext['exports']! as JSObject;
  }

  static Future<JSObject> _loadEtebase(JSObject exports) async {
    final didLoad = await _loadJs('etebase', _etebaseJsPath);
    final etebase =
        (exports['Etebase'] ?? globalContext['Etebase'])! as JSObject;

    if (didLoad) {
      await (etebase['ready']! as JSPromise).toDart;
    }

    return etebase;
  }

  static Future<JSObject> _loadTestUtils(JSObject exports) async {
    await _loadJs('testUtils', _testUtilsJsPath);
    return exports['testUtils']! as JSObject;
  }

  static Future<JSFunction> _loadRun(JSObject exports) async {
    await _loadJs('run', _runJsPath);
    return exports['run']! as JSFunction;
  }

  static Future<bool> _loadJs(String id, String path) async {
    final element = document.getElementById(id);
    if (element != null) {
      return false;
    }

    final channel = spawnHybridCode(_vmCode, message: path);
    final jsBundle = await channel.stream.cast<String>().first;

    final script = HTMLScriptElement()
      ..id = id
      ..text = jsBundle;
    document.head!.append(script);

    await Future<void>.delayed(Duration.zero);
    return true;
  }
}
