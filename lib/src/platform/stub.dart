import 'io.dart' if (dart.library.html) 'web.dart';

class StabilityPlatform {
  static final instance = StabilityPlatformImpl();

  String? get apiKeyEnv => null;
}
