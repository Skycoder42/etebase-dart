void main(List<String> args) async {
  print('CREATE');
  final s = test();
  await Future<void>.delayed(const Duration(seconds: 1));
  s.listen(null, onError: print, cancelOnError: false);
}

Stream<int> test() async* {
  try {
    print('GO');
    yield* Stream.error(Exception('TEST1'));
    await for (final event in Stream<int>.error(Exception('TEST2'))) {
      yield event;
    }
    yield* Stream.error(Exception('TEST3'));
  } catch (e) {
    print('CATCHED $e');
  }
}
