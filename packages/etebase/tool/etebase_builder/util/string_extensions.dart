extension StringX on String {
  String snakeToDart() =>
      replaceAllMapped(RegExp(r'_(\w)'), (match) => match[1]!.toUpperCase());

  String lowerFirstChar() =>
      isEmpty ? this : '${this[0].toLowerCase()}${substring(1)}';
}
