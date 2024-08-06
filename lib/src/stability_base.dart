library stability_base;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:stability/src/utils/types.dart';

part 'utils/fetcher.dart';
part 'modules/user.dart';
part 'modules/sdxl.dart';
part 'modules/3d.dart';
part 'modules/engines.dart';
part 'modules/image_to_video.dart';
part 'modules/image/control.dart';
part 'modules/image/edit.dart';
part 'modules/image/generate.dart';
part 'modules/image/upscale.dart';
part 'modules/image/stable_image.dart';

mixin _PathSegment {
  String get _path;

  _PathSegment? get _parent;

  _StabilityFetcher get _fetcher {
    return _parent!._fetcher;
  }

  String _buildPath() {
    if (_parent == null) {
      return _path;
    }

    return "${_parent!._buildPath()}/$_path";
  }
}

class StabilityAI with _PathSegment {

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

  StabilityAI({String? apiKey}) : _fetcher = _StabilityFetcher() {
    final apiK = apiKey ?? apiKeyEnv;

    if (apiK == null) {
      throw ArgumentError("API Key is required");
    }

    _fetcher._defaultHeaders["Authorization"] = "Bearer $apiK";
  }

  @override
  final _StabilityFetcher _fetcher;

  @override
  _PathSegment? get _parent => null;

  @override
  String get _path => "https://api.stability.ai";

  UserModule get user => UserModule(this);

  SDXL get sdxl => SDXL(this);

  EngineModule get engines => EngineModule(this);
}
