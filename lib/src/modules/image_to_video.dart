part of '../stability_base.dart';

/// Image-to-Video
///
/// [Read More](https://platform.stability.ai/docs/api-reference#tag/Image-to-Video)
class ImageToVideoModule with _PathSegment {
  ImageToVideoModule._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "v2beta/image-to-video";

  /// ## Start Generation
  ///
  /// Generate a short video based on an initial image with Stable Video
  /// Diffusion, a latent video diffusion model.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Image-to-Video/paths/~1v2beta~1image-to-video/post)
  Future<String> startGeneration(
      {required FileFrom image,
      double? cfgScale,
      int? motionBucketId,
      int? seed}) {
    ensureCfgScale(cfgScale);
    ensureMin(seed, 0, "seed");
    ensureRange(motionBucketId, 1, 255, "motion_bucket_id");

    final body = {
      "image": image.toMultipartFile("image"),
      if (cfgScale != null) "cfg_scale": cfgScale,
      if (motionBucketId != null) "motion_bucket_id": motionBucketId,
      if (seed != null) "seed": seed
    };

    return _fetcher
        ._jsonRequest(this, "", "POST", body: body)
        .readAsJson<Map<String, dynamic>>()
        .then((e) => e['id'] as String);
  }

  /// ## Fetch generation result
  ///
  /// Fetch the result of an image-to-video generation by ID.
  ///
  /// Make sure to use the same API key to fetch the generation result that
  /// you used to create the generation, otherwise you will receive a 404 response.
  ///
  /// Get the status of a generation
  /// Returns null if the generation is still in progress
  ///
  /// Throws an error if the generation failed
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Image-to-Video/paths/~1v2beta~1image-to-video~1result~1%7Bid%7D/get)
  Future<FileHandler?> getGeneration(String id) async {
    final res =
        _fetcher._jsonRequest(this, "/result/$id", "GET", body: null, headers: {
      "Accept": "video/*",
    });

    final internalRes = await res._response;

    if (internalRes.statusCode == 200) {
      return FileHandler._(res);
    }

    if (internalRes.statusCode == 202) {
      return null;
    }

    res._throwIfNotOk();

    return null;
  }
}
