import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:test/test.dart';
import 'package:web/web.dart';

import 'js_client_wrapper_stub.dart';

@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject object);

abstract base class JsClientWrapper {
  static const _etebaseJsPath = 'node_modules/etebase/dist/umd/Etebase.js';
  static const _vmCode = r'''
import 'dart:io';

import 'package:stream_channel/stream_channel.dart';

Future<void> hybridMain(StreamChannel channel, Object? message) async {
  final jsBundleFile = File('tool/js_client/$message');
  final jsBundle = await jsBundleFile.readAsString();
  channel.sink.add(jsBundle);
}
''';

  static Future<TRes> execute<TRes>(
    Action action, {
    bool useDefaultServer = false,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) async {
    print(globalContext.has('exports'));
    await _loadJs('etebase', _etebaseJsPath);
    print(globalContext.has('exports'));
    await _loadJs(action.$type, 'dist/actions/${action.$type}.js');
    print(globalContext.has('exports'));

    return null as TRes;
  }

  static Future<void> _loadJs(String id, String path) async {
    final element = document.getElementById(id);
    if (element != null) {
      return;
    }

    final channel = spawnHybridCode(_vmCode, message: path);
    final jsBundle = await channel.stream.cast<String>().first;

    final script = HTMLScriptElement()
      ..id = id
      ..text = jsBundle;
    document.head!.append(script);

    await Future<void>.delayed(Duration.zero);
  }
}
