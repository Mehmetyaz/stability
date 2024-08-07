part of '../../stability_base.dart';

/// Generate an image using a Stable Diffusion 3 model:
///
/// SD3 Medium - the 2 billion parameter model
/// SD3 Large - the 8 billion parameter model
/// SD3 Large Turbo - the 8 billion parameter model with a faster inference time
///
enum Diffusion3Model {
  /// The 2 billion parameter model
  sd3Large("sd3-large"),

  /// The 8 billion parameter model
  sd3Small("sd3-medium"),

  /// The 8 billion parameter model with a faster inference time
  sd3LargeTurbo("sd3-large-turbo");

  /// The value of the model.
  final String value;

  /// Creates a new [Diffusion3Model] instance.
  const Diffusion3Model(this.value);
}

/// Tools for generating new images or variations of existing images.
///
/// [Read More](https://platform.stability.ai/docs/api-reference#tag/Generate)
class StableImageGenerate with _PathSegment {
  StableImageGenerate._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "generate";

  /// ## Stable Image Ultra
  ///
  /// Our most advanced text to image generation service, Stable Image Ultra
  /// creates the highest quality images with unprecedented prompt
  /// understanding. Ultra excels in typography, complex compositions, dynamic
  /// lighting, vibrant hues, and overall cohesion and structure of an art
  /// piece. Made from the most advanced models, including Stable Diffusion 3,
  /// Ultra offers the best of the Stable Diffusion ecosystem.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1ultra/post)
  FileHandler ultra({
    required String prompt,
    String? negativePrompt,
    AspectRatio? aspectRatio,
    int? seed,
    OutputFormat? outputFormat,
  }) {
    final body = {
      "prompt": prompt,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
      if (aspectRatio != null) "aspect_ratio": aspectRatio.value,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
    };

    return FileHandler._(_fetcher
        ._multipartRequest(this, "/ultra", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }

  /// ## Stable Image Core
  ///
  /// Our primary service for text-to-image generation, Stable Image Core
  /// represents the best quality achievable at high speed. No prompt
  /// engineering is required! Try asking for a style, a scene, or a character,
  /// and see what you get.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1core/post)
  FileHandler core({
    required String prompt,
    String? negativePrompt,
    AspectRatio? aspectRatio,
    int? seed,
    OutputFormat? outputFormat,
    StylePreset? stylePreset,
  }) {
    final body = {
      "prompt": prompt,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
      if (aspectRatio != null) "aspect_ratio": aspectRatio.value,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
      if (stylePreset != null) "style_preset": stylePreset.name,
    };

    return FileHandler._(
        _fetcher._multipartRequest(this, "/core", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }

  /// Generate an image using a Stable Diffusion 3 model:
  ///
  /// SD3 Medium - the 2 billion parameter model
  /// SD3 Large - the 8 billion parameter model
  /// SD3 Large Turbo - the 8 billion parameter model with a faster inference time
  ///
  /// Commonly referred to as text-to-image, this mode generates an image from
  /// text alone. While the only required parameter is the prompt, it also
  /// supports an aspect_ratio parameter which can be used to control the
  /// aspect ratio of the generated image.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1sd3/post)
  FileHandler diffusion3Text2Image({
    required String prompt,
    AspectRatio? aspectRatio,
    Diffusion3Model? model,
    int? seed,
    OutputFormat? outputFormat,
    String? negativePrompt,
  }) {
    final body = {
      "prompt": prompt,
      if (aspectRatio != null) "aspect_ratio": aspectRatio.value,
      if (model != null) "model": model.value,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
    };

    return FileHandler._(
        _fetcher._multipartRequest(this, "/sd3", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }

  ///
  /// Commonly referred to as image-to-image, this mode also generates an image
  /// from text but uses an existing image as the starting point. The required
  /// parameters are:
  ///
  /// prompt - text to generate the image from
  /// image - the image to use as the starting point for the generation
  /// strength - controls how much influence the image parameter has on the output image
  /// mode - must be set to image-to-image
  /// Note: maximum request size is 10MiB.
  ///
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1sd3/post)
  FileHandler diffusion3Image2Image({
    required FileFrom image,
    required double strength,
    String? prompt,
    AspectRatio? aspectRatio,
    Diffusion3Model? model,
    int? seed,
    OutputFormat? outputFormat,
    String? negativePrompt,
  }) {
    ensureRange(strength, 0, 1, "strength");

    final body = {
      "image": image.toMultipartFile("image"),
      "strength": strength,
      "mode": "image-to-image",
      if (prompt != null) "prompt": prompt,
      if (aspectRatio != null) "aspect_ratio": aspectRatio.value,
      if (model != null) "model": model.value,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
    };

    return FileHandler._(
        _fetcher._multipartRequest(this, "/sd3", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }
}
