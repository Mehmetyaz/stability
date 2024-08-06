part of '../stability_base.dart';

/// The resolution of the generated texture.
enum TextureResolution {
  /// `512`
  low(512),

  /// `1024`
  medium(1024),

  /// `2048`
  high(2048);

  final int value;

  const TextureResolution(this.value);
}

/// A module for interacting with the Stable Fast 3D API.
///
/// [Read More](https://platform.stability.ai/docs/api-reference#tag/3D)
class D3DModule with _PathSegment {
  D3DModule._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "v2beta/3d/stable-fast-3d";

  /// Stable Fast 3D generates high-quality 3D assets from a single 2D input image.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/3D/paths/~1v2beta~13d~1stable-fast-3d/post)
  FileHandler generate({
    required FileFrom image,
    TextureResolution? textureResolution,
    double? foregroundRatio,
  }) {
    ensureRange(foregroundRatio, 1, 255, "motion_bucket_id");

    final body = {
      "image": image.toMultipartFile("image"),
      if (textureResolution != null)
        "texture_resolution": textureResolution.value,
      if (foregroundRatio != null) "foreground_ratio": foregroundRatio,
    };

    return FileHandler._(
        _fetcher._multipartRequest(this, "", "POST", body: body));
  }
}
