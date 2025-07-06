class MissingTypeRegistrationError extends Error {
  final Type type;

  MissingTypeRegistrationError(this.type);

  @override
  String toString() =>
      'MissingTypeRegistrationError: '
      'Type $type was not registered as repository type';
}
