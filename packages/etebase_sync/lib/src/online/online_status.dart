enum OnlineStatus {
  online(true),
  offline(false);

  final bool isOnline;

  // ignore: avoid_positional_boolean_parameters single parameter
  const OnlineStatus(this.isOnline);
}
