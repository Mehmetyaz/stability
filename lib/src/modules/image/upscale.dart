part of '../../stability_base.dart';

/// Stable Image Upscale module.
///
/// https://platform.stability.ai/docs/api-reference#tag/Upscale
class StableImageUpscale with _PathSegment {
  StableImageUpscale._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "upscale";

  /// ## Conservative
  ///
  /// Takes images between 64x64 and 1 megapixel and upscales them all the way
  /// to 4K resolution. Put more generally, it can upscale images ~20-40x times
  /// while preserving all aspects. Conservative Upscale minimizes alterations
  /// to the image and should not be used to reimagine an image.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Upscale/paths/~1v2beta~1stable-image~1upscale~1conservative/post)
  FileHandler conservative({
    required FileFrom image,
    required String prompt,
    String? negativePrompt,
    int? seed,
    OutputFormat? outputFormat = OutputFormat.png,
    double? creativity,
  }) {
    ensureMin(seed, 0, "seed");
    ensureRange(creativity, 0.2, 0.5, "creativity");

    final body = {
      "image": image.toMultipartFile("image"),
      "prompt": prompt,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
      if (creativity != null) "creativity": creativity,
    };

    return FileHandler._(_fetcher
        ._multipartRequest(this, "/conservative", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }

  /// ## Start Creative Upscale
  ///
  /// Takes images between 64x64 and 1 megapixel and upscales them all the way
  /// to 4K resolution. Put more generally, it can upscale images ~20-40x times
  /// while preserving, and often enhancing, quality. Creative Upscale works
  /// best on highly degraded images and is not for photos of 1mp or above as
  /// it performs heavy reimagining (controlled by creativity scale).
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Upscale/paths/~1v2beta~1stable-image~1upscale~1creative/post)
  Future<String> startCreativeUpscale({
    required FileFrom image,
    required String prompt,
    String? negativePrompt,
    OutputFormat? outputFormat = OutputFormat.png,
    int? seed,
    double? creativity,
  }) {
    ensureMin(seed, 0, "seed");
    ensureRange(creativity, 0, 0.35, "creativity");

    final body = {
      "image": image.toMultipartFile("image"),
      "prompt": prompt,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
      if (creativity != null) "creativity": creativity,
    };

    return _fetcher
        ._multipartRequest(this, "/creative", "POST", body: body, headers: {
          "Accept": "image/*",
        })
        .readAsJson()
        .then((value) {
          return value["id"];
        });
  }

  /// ## Fetch Creative Upscale result
  ///
  /// Fetch the result of an upscale generation by ID.
  ///
  /// Make sure to use the same API key to fetch the generation result that you
  /// used to create the generation, otherwise you will receive a 404 response.
  ///
  /// Returns a [FileHandler] if the generation is complete, otherwise returns
  /// `null`.
  ///
  /// If there was an error during generation, this method will throw an error.
  Future<FileHandler?> fetchCreativeResult(String id) async {
    final res =
        _fetcher._jsonRequest(this, "/creative/result/$id", "GET", body: null);

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
