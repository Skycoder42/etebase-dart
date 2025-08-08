void main(List<String> args) async {
  print(await Stream.fromFuture(Future<void>.value()).cast<String?>().toList());
}
