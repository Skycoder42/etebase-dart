abstract base class BuildTargetBase {
  const BuildTargetBase();

  String get name;

  String get rustTarget;

  bool get openSslVendored;

  Map<String, String> get buildEnv => const {};

  List<String> get extraBuildArgs => const [];
}
