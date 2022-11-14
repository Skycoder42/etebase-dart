extension StringX on String {
  String snakeToDart() =>
      replaceAllMapped(RegExp(r'_(\w)'), (match) => match[1]!.toUpperCase());
}
