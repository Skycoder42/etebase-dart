import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/rollsum.dart';
import 'package:etebase/src/impl/encrypted_models/chunker_sink.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<EventSink<Uint8List>>(), MockSpec<Rollsum>()])
import 'chunker_sink_test.mocks.dart';

void main() {
  group('$ChunkerSink', () {
    final mockEventSink = MockEventSink();
    final mockRollsum = MockRollsum();

    late ChunkerSink sut;

    void setupChunkSplit(int chunkSize) {
      var ctr = 0;
      when(mockRollsum.update(any)).thenAnswer((i) {
        ctr++;
      });
      when(mockRollsum.split(any)).thenAnswer((i) {
        if (ctr >= chunkSize) {
          ctr -= chunkSize;
          return true;
        }
        return false;
      });
    }

    Iterable<dynamic> updatesFor(Iterable<int> data) =>
        data.map(mockRollsum.update);

    setUp(() {
      reset(mockEventSink);
      reset(mockRollsum);

      sut = ChunkerSink(mockEventSink, mockRollsum);
    });

    group('add and close', () {
      test('forwards small data as is', () {
        final testData = Uint8List.fromList([1, 2, 3]);

        sut
          ..add(testData)
          ..close();

        verifyInOrder([
          ...updatesFor(testData),
          mockEventSink.add(testData),
          mockEventSink.close(),
        ]);
      });

      test('combines multiple small chunks into one', () {
        final testData1 = Uint8List.fromList([1, 2, 3]);
        final testData2 = Uint8List.fromList([4, 5, 6]);
        final testData3 = Uint8List.fromList([7, 8, 9]);

        sut
          ..add(testData1)
          ..add(testData2)
          ..add(testData3)
          ..close();

        verifyInOrder([
          ...updatesFor(testData1),
          ...updatesFor(testData2),
          ...updatesFor(testData3),
          mockEventSink.add(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9])),
          mockEventSink.close(),
        ]);
      });

      test('never splits below min chunk length', () {
        final testData = Uint8List.fromList(
          List.filled(ChunkerSink.minChunk - 1, 1),
        );

        when(mockRollsum.split(any)).thenReturn(true);

        sut
          ..add(testData)
          ..close();

        verifyInOrder([mockEventSink.add(testData), mockEventSink.close()]);
        verifyNever(mockRollsum.split(any));
      });

      test('always splits above max chunk length', () {
        final testData = Uint8List.fromList(
          List.generate(ChunkerSink.maxChunk + 3, (i) => i % 256),
        );

        when(mockRollsum.split(any)).thenReturn(false);

        sut
          ..add(testData)
          ..close();

        verifyInOrder([
          mockEventSink.add(testData.sublist(0, ChunkerSink.maxChunk)),
          mockEventSink.add(testData.sublist(ChunkerSink.maxChunk)),
          mockEventSink.close(),
        ]);
        verify(mockRollsum.split(ChunkerSink.mask))
            .called(ChunkerSink.maxChunk - ChunkerSink.minChunk);
      });

      test(
        'splits when chunker signals if between min and max chunk length',
        () {
          const testChunkSize = 1 << 15;
          setupChunkSplit(testChunkSize);

          final testData = Uint8List.fromList(
            List.generate(testChunkSize * 3, (i) => i % 256),
          );

          sut
            ..add(testData)
            ..close();

          verifyInOrder([
            mockEventSink.add(testData.sublist(0, testChunkSize)),
            mockEventSink.add(
              testData.sublist(testChunkSize, testChunkSize * 2),
            ),
            mockEventSink.add(testData.sublist(testChunkSize * 2)),
            mockEventSink.close(),
          ]);
        },
      );

      test('combines irregular chunks to uniform ones', () {
        final random = Random.secure();

        const totalLen = 2476882;
        const totalChunks = totalLen / ChunkerSink.maxChunk;
        final fullChunks = totalChunks.floor();

        var remainingLen = totalLen;
        var offset = -1;
        while (remainingLen > 0) {
          final bestLen = random.nextInt((totalLen / 16).ceil());
          final length = min(bestLen, remainingLen);
          remainingLen -= length;
          sut.add(List.generate(length, (_) => offset = (++offset) % 100));
        }
        sut.close();

        final allChunks = Uint8List.fromList(
          List.generate(totalLen, (i) => i % 100),
        );
        verifyInOrder([
          for (var i = 0; i < fullChunks; ++i)
            mockEventSink.add(
              allChunks.sublist(
                ChunkerSink.maxChunk * i,
                ChunkerSink.maxChunk * (i + 1),
              ),
            ),
          mockEventSink.add(
            allChunks.sublist(ChunkerSink.maxChunk * fullChunks),
          ),
          mockEventSink.close(),
        ]);
      });
    });

    test('addError forwards error to sink', () {
      final testError = Exception('test');
      final testTrace = StackTrace.current;

      sut.addError(testError, testTrace);

      verify(mockEventSink.addError(testError, testTrace)).called(1);
    });
  });
}
