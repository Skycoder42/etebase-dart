import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

@internal
class ListCastEncoder extends Converter<List<int>, Uint8List> {
  const ListCastEncoder();

  @override
  Uint8List convert(List<int> input) => switch (input) {
        Uint8List() => input,
        _ => Uint8List.fromList(input),
      };
}

@internal
class ListCastDecoder extends Converter<Uint8List, List<int>> {
  const ListCastDecoder();

  @override
  List<int> convert(Uint8List input) => input;
}

@internal
class ListCastCodec extends Codec<List<int>, Uint8List> {
  const ListCastCodec();

  @override
  ListCastEncoder get encoder => const ListCastEncoder();

  @override
  ListCastDecoder get decoder => const ListCastDecoder();
}
