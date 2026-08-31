// ignore_for_file: unnecessary_ignore, conditional_uri_does_not_exist

import 'package:web/web.dart';

import 'sodium.js.fake.dart'
    if (dart.library.js) '../../../tool/integration/cache/sodium/sodium.js.dart'
    as sodium_sumo_js;

const kIsWeb = true;

bool didAttach = false;
void prepareSodium() {
  if (didAttach) return;

  final script = HTMLScriptElement()..text = sodium_sumo_js.src;
  document.head!.append(script);
  didAttach = true;
}
