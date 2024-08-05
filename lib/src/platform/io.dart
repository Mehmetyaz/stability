import 'dart:io';

import 'stub.dart';

class StabilityPlatformImpl extends StabilityPlatform {

  @override
  String? get apiKeyEnv {
    final fromEnv = Platform.environment["STABILITY_API_KEY"];

    if (fromEnv != null) {
      return fromEnv;
    }

    final argIndex = Platform.executableArguments.indexOf(
        "--stability-api-key");

    if (argIndex != -1) {
      if (argIndex + 1 >= Platform.executableArguments.length) {
        throw ArgumentError("Missing value for --stability-api-key");
      }
      return Platform.executableArguments[argIndex + 1];
    }

    return null;
  }


}