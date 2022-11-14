class MethodInvocation {
  final int id;
  final Symbol method;
  final List<Object?> arguments;

  const MethodInvocation(this.id, this.method, this.arguments);
}
