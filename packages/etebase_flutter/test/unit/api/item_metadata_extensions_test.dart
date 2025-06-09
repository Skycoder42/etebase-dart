import 'package:dart_test_tools/test.dart';
import 'package:etebase/etebase.dart';
import 'package:etebase_flutter/src/api/item_metadata_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemMetadataExtensions', () {
    group('colorValue', () {
      testData(
        'maps color string to actual color values',
        [
          (null, null),
          ('#123456', const Color(0xFF123456)),
          ('#12345678', const Color(0x78123456)),
        ],
        (fixture) {
          final sut = ItemMetadata(color: fixture.$1);
          expect(sut.colorValue, fixture.$2);
        },
      );

      test('throws if color is of wrong format', () {
        const sut = ItemMetadata(color: '#123');
        expect(() => sut.colorValue, throwsA(isA<ApiMissuse>()));
      });
    });

    testData(
      'copyWithColor sets color value as hex string',
      [
        (Colors.black, false, '#000000'),
        (const Color(0x12345678), false, '#345678'),
        (const Color(0x12345678), true, '#34567812'),
      ],
      (fixture) {
        final sut = ItemMetadata(
          color: 'invalid',
          name: 'testName',
          description: 'testDescription',
          itemType: 'testItemType',
          mtime: DateTime.now(),
        );

        final result = sut.copyWithColor(fixture.$1, withAlpha: fixture.$2);

        expect(result, sut.copyWith(color: fixture.$3));
      },
    );
  });

  testData(
    'flutterItemMetadata constructs item metadata with color',
    [
      (Colors.black, false, '#000000'),
      (const Color(0x12345678), false, '#345678'),
      (const Color(0x12345678), true, '#34567812'),
    ],
    (fixture) {
      final now = DateTime.now();
      final sut = flutterItemMetadata(
        color: fixture.$1,
        name: 'testName',
        description: 'testDescription',
        itemType: 'testItemType',
        mtime: now,
        withAlpha: fixture.$2,
      );

      expect(
        sut,
        ItemMetadata(
          color: fixture.$3,
          name: 'testName',
          description: 'testDescription',
          itemType: 'testItemType',
          mtime: now,
        ),
      );
    },
  );
}
