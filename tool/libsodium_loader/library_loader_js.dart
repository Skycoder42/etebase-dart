import 'dart:async';
import 'dart:js_interop';

import 'package:sodium/sodium.js.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

const _hybridMain = r'''
import 'dart:io';
import 'package:stream_channel/stream_channel.dart';

Future<void> hybridMain(StreamChannel channel) async {
  try {
    final prefix = Platform.environment['GITHUB_WORKSPACE'] ?? '../..';
    final jsFile = File('$prefix/tool/libsodium_loader/sodium.js');
    final jsContent = await jsFile.readAsString();
    channel.sink.add(jsContent);
  } catch (e, s) {
    channel.sink.addError(e, s);
  }
}
''';

const kIsWeb = true;

extension type SodiumBrowserInit._(JSObject _) implements JSObject {
  external JSFunction get onload;

  external SodiumBrowserInit({JSFunction onload});
}

@JS()
external SodiumBrowserInit? get sodium;

@JS()
external set sodium(SodiumBrowserInit? value);

Future<LibSodiumJS> getLibsodium() async {
  final hybridChannel = spawnHybridCode(_hybridMain);
  final sodiumJs = await hybridChannel.stream.cast<String>().first;

  final completer = Completer<LibSodiumJS>();

  void onload(LibSodiumJS sodium) => completer.complete(sodium);

  sodium = SodiumBrowserInit(onload: onload.toJS);

  final script = HTMLScriptElement()..text = sodiumJs;
  document.head!.append(script);

  return await completer.future;
}
