library stability_base;

import 'package:stability/src/platform/stub.dart';

class StabilityAI {
  StabilityAI({String? apiKey}) {
    final apiK = apiKey ?? StabilityPlatform.instance.apiKeyEnv;

    if (apiK == null) {
      throw ArgumentError("API Key is required");
    }

    _defaultHeaders["Authorization"] = "Bearer $apiK";
  }

  final Map<String, String> _defaultHeaders = {};

  final String _baseUrl = "https://api.stability.ai";



}

abstract class StabilityModule {
  final StabilityAI _stabilityAI;

  StabilityModule(this._stabilityAI);

  String get segment;



}