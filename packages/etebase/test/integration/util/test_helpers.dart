import 'package:test/test.dart';

Matcher dtEquals(
  DateTime dt, [
  Duration maxDelta = const Duration(microseconds: 999),
]) => predicate<DateTime>((value) {
  final delta = value.difference(dt);
  return delta.abs() <= maxDelta;
}, 'differs by more then $maxDelta');
