library stability_base;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

part 'utils/types.dart';
part 'utils/validators.dart';
part 'utils/fetcher.dart';

part 'modules/user.dart';

part 'modules/sdxl.dart';

part 'modules/d3d.dart';

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

/// The main class for interacting with the Stability AI API
///
/// To use this class, you need to have an API key. You can provide the API key
/// as an argument to the constructor or set it as an environment variable
/// `STABILITY_API_KEY`. You can also provide the API key as an argument when
/// running the script using `--stability-api-key`.
///
///
/// This class provides access to the following modules:
///
/// - [UserModule]: For user related operations
/// - [EngineModule] : For listing and getting information about engines
/// - [SDXLWithMaskModule] : For using the Stable Diffusion XL model with `stable-diffusion-xl-1024-v1-0` model
/// - [SDXLModule] : For using the Stable Diffusion XL model with `stable-diffusion-v1-6` model
/// - [D3DModule] : For using the Diffusion 3D model
/// - [ImageToVideoModule] : For converting images to videos
/// - [StableImageModule] : For image related operations like editing, generating,
/// upscaling, etc.
///
///
/// This package prepared by using [the documentation](https://platform.stability.ai/docs/getting-started)
class StabilityAI with _PathSegment {
  String? get _apiKeyEnv {
    final fromEnv = Platform.environment["STABILITY_API_KEY"];

    if (fromEnv != null) {
      return fromEnv;
    }

    final argIndex =
        Platform.executableArguments.indexOf("--stability-api-key");

    if (argIndex != -1) {
      if (argIndex + 1 >= Platform.executableArguments.length) {
        throw ArgumentError("Missing value for --stability-api-key");
      }
      return Platform.executableArguments[argIndex + 1];
    }

    return null;
  }

  /// Create a new [StabilityAI] instance.
  ///
  /// The [apiKey] is required. You can also set the API key as an environment variable
  /// `STABILITY_API_KEY` or provide it as an argument when running the script using
  /// `--stability-api-key`.
  ///
  /// You can also provide the [stabilityClientId] and [stabilityClientUserId]
  StabilityAI(
      {String? apiKey,
      String? stabilityClientId,
      String? stabilityClientUserId})
      : _fetcher = _StabilityFetcher() {
    final apiK = apiKey ?? _apiKeyEnv;

    if (apiK == null) {
      throw ArgumentError("API Key is required");
    }

    _fetcher._defaultHeaders["Authorization"] = "Bearer $apiK";

    if (stabilityClientId != null) {
      _fetcher._defaultHeaders["stability-client-id"] = stabilityClientId;
    }

    if (stabilityClientUserId != null) {
      _fetcher._defaultHeaders["stability-client-user-id"] =
          stabilityClientUserId;
    }
  }

  @override
  final _StabilityFetcher _fetcher;

  @override
  _PathSegment? get _parent => null;

  @override
  String get _path => "https://api.stability.ai";

  /// The [UserModule] for user related operations
  UserModule get user => UserModule._(this);

  /// The [EngineModule] for listing and getting information about engines
  EngineModule get engines => EngineModule._(this);

  /// The [SDXLWithMaskModule] for using the Stable Diffusion XL model with `stable-diffusion-xl-1024-v1-0` model
  SDXLWithMaskModule get sdxlV1 =>
      SDXLWithMaskModule._(this, "stable-diffusion-xl-1024-v1-0");

  /// The [SDXLModule] for using the Stable Diffusion XL with ``stable-diffusion-xl-1024-v1-0`` model
  SDXLModule get sdxlV16 => SDXLModule._(this, "stable-diffusion-v1-6");

  /// The [SDXLModule] for using the Stable Diffusion XL model
  SDXLModule get sdBeta =>
      SDXLModule._(this, "stable-diffusion-xl-beta-v2-2-2");

  /// The [D3DModule] for using the Diffusion 3D model
  D3DModule get d3d => D3DModule._(this);

  /// The [ImageToVideoModule] for converting images to videos
  ImageToVideoModule get imageToVideo => ImageToVideoModule._(this);

  /// The [StableImageModule] for image related operations like editing, generating,
  /// upscaling, etc.
  StableImageModule get image => StableImageModule._(this);
}
