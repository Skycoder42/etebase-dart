import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../crypto/rollsum.dart';

@internal
class ChunkerSink implements EventSink<List<int>> {
  static const minChunk = 1 << 14;
  static const maxChunk = 1 << 16;
  static const mask = (1 << 12) - 1;

  final EventSink<Uint8List> sink;
  final Rollsum chunker;

  final _chunkBuilder = BytesBuilder(copy: false);

  new(this.sink, this.chunker);

  @override
  void add(List<int> event) {
    var chunkLen = _chunkBuilder.length;
    var chunkStart = 0;
    for (var pos = 0; pos < event.length; ++pos) {
      chunker.update(event[pos]);
      chunkLen++;

      if (chunkLen >= minChunk) {
        if (chunkLen >= maxChunk || chunker.split(mask)) {
          _chunkBuilder.add(_sublistView(event, chunkStart, pos + 1));
          sink.add(_chunkBuilder.takeBytes());
          chunkStart = pos + 1;
          chunkLen = 0;
        }
      }
    }

    if (chunkStart < event.length) {
      _chunkBuilder.add(_sublistView(event, chunkStart));
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      sink.addError(error, stackTrace);

  @override
  void close() {
    if (_chunkBuilder.isNotEmpty) {
      sink.add(_chunkBuilder.takeBytes());
    }
    sink.close();
  }

  Uint8List _sublistView(List<int> data, int start, [int? end]) {
    if (data is Uint8List) {
      return Uint8List.sublistView(data, start, end);
    } else {
      // efficient copy to Uint8List
      final copySize = (end ?? data.length) - start;
      return Uint8List(copySize)..setRange(0, copySize, data, start);
    }
  }
}

@internal
class ChunkerStreamTransformer
    extends StreamTransformerBase<List<int>, Uint8List> {
  final Rollsum chunker;

  const new(this.chunker);

  @override
  Stream<Uint8List> bind(Stream<List<int>> stream) =>
      Stream.eventTransformed(stream, (sink) => ChunkerSink(sink, chunker));
}

@internal
extension Uint8ListStreamX on Stream<List<int>> {
  Stream<Uint8List> chunked(Rollsum chunker) =>
      transform(ChunkerStreamTransformer(chunker));
}
