import 'dart:collection';
import 'dart:typed_data';

import 'package:etebase/src/impl/codec/type_converter.dart';
import 'package:test/test.dart';

void main() {
  group('$TypeConverter', () {
    group('default', () {
      int fromJson(Map<String, dynamic> json) => json['v'] as int;

      final sut = TypeConverter(fromJson);

      test('allows conversion of various maps', () {
        expect(sut({'v': 42}), 42);
        expect(sut(<String, dynamic>{'v': 42}), 42);
        expect(sut(<dynamic, int>{'v': 42}), 42);
        expect(sut(<dynamic, dynamic>{'v': 42}), 42);
        expect(sut(HashMap<dynamic, num>.from({'v': 42})), 42);
      });
    });

    group('list', () {
      int fromJson(List<dynamic> json) => json[0] as int;

      final sut = TypeConverter.list(fromJson);

      test('allows conversion of various lists', () {
        expect(sut([42]), 42);
        expect(sut(<dynamic>[42]), 42);
        expect(sut(<num>[42]), 42);
        expect(sut(Uint8List.fromList([42])), 42);
      });
    });

    group('generic', () {
      int fromJson(Map<String, dynamic> json) => json['v'] as int;

      List<int> containerFromJson(
        Map<String, dynamic> json,
        int Function(Object?) fromJson,
      ) =>
          json.values.map(fromJson).toList();

      final sut = TypeConverter.generic(containerFromJson, fromJson);

      test('allows conversion of various maps', () {
        expect(
          sut({
            'a': {'v': 42},
            'b': {'v': 24},
          }),
          [42, 24],
        );

        expect(
          sut(<dynamic, dynamic>{
            'a': <dynamic, dynamic>{'v': 42},
            'b': <dynamic, num>{'v': 24},
          }),
          [42, 24],
        );

        expect(
          sut(
            HashMap<dynamic, dynamic>.from({
              'a': HashMap<dynamic, num>.from({'v': 42}),
              'b': SplayTreeMap<String, dynamic>.from({'v': 24}),
            }),
          ),
          [42, 24],
        );
      });
    });
  });
}
