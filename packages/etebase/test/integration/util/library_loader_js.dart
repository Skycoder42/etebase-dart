import 'dart:async';
import 'dart:js_interop';

import 'package:sodium/sodium.js.dart';
import 'package:web/web.dart';

import 'sodium.js.fake.dart'
    // ignore: conditional_uri_does_not_exist
    if (dart.library.js) '../../../tool/integration/cache/sodium/sodium.js.dart'
    as sodium_sumo_js;

const kIsWeb = true;

extension type SodiumBrowserInit._(JSObject _) implements JSObject {
  external JSFunction get onload;

  external SodiumBrowserInit({JSFunction onload});
}

@JS()
external SodiumBrowserInit? get sodium;

@JS()
external set sodium(SodiumBrowserInit? value);

Future<LibSodiumJS> getLibsodium() {
  final completer = Completer<LibSodiumJS>();

  void onload(LibSodiumJS sodium) => completer.complete(sodium);

  sodium = SodiumBrowserInit(onload: onload.toJS);

  final script = HTMLScriptElement()..text = sodium_sumo_js.src;
  document.head!.append(script);

  return completer.future;
}
