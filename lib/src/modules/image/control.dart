part of '../../stability_base.dart';

/// Tools for generating precise, controlled variations of existing images or sketches.
class StableImageControl with _PathSegment {
  StableImageControl._(this._parent);

  @override
  final _PathSegment? _parent;

  @override
  String get _path => "control";

  FileHandler _req(
      {required FileFrom image,
      required String prompt,
      double? fidelity,
      double? controlStrength,
      String? negativePrompt,
      int? seed,
      OutputFormat outputFormat = OutputFormat.png,
      AspectRatio? aspectRatio,
      required String p}) {
    ensureRange(controlStrength, 0, 1, "control_strength");
    ensureMin(seed, 0, "seed");
    ensureRange(fidelity, 0, 1, "fidelity");

    final body = {
      "image": image.toMultipartFile("image"),
      "prompt": prompt,
      if (controlStrength != null) "control_strength": controlStrength,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
      if (seed != null) "seed": seed,
      "output_format": outputFormat.name,
      if (aspectRatio != null) "aspect_ratio": aspectRatio.value,
      if (fidelity != null) "fidelity": fidelity,
    };

    return FileHandler._(
        _fetcher._multipartRequest(this, "/$p", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }

  /// ## Structure
  ///
  /// This service excels in generating images by maintaining the structure
  /// of an input image, making it especially valuable for advanced content
  /// creation scenarios such as recreating scenes or rendering characters
  /// from models.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Control/paths/~1v2beta~1stable-image~1control~1structure/post)
  FileHandler structure({
    required FileFrom image,
    required String prompt,
    double? controlStrength,
    String? negativePrompt,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
  }) {
    return _req(
      image: image,
      prompt: prompt,
      p: "structure",
      controlStrength: controlStrength,
      negativePrompt: negativePrompt,
      outputFormat: outputFormat,
      seed: seed,
    );
  }

  /// ## Style
  ///
  /// This service extracts stylistic elements from an input image
  /// (control image) and uses it to guide the creation of an output image
  /// based on the prompt. The result is a new image in the same style as the
  /// control image.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Control/paths/~1v2beta~1stable-image~1control~1style/post)
  FileHandler style({
    required FileFrom image,
    required String prompt,
    double? controlStrength,
    String? negativePrompt,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
    AspectRatio? aspectRatio,
    double? fidelity,
  }) {
    return _req(
      image: image,
      prompt: prompt,
      p: "style",
      controlStrength: controlStrength,
      negativePrompt: negativePrompt,
      outputFormat: outputFormat,
      seed: seed,
      aspectRatio: aspectRatio,
      fidelity: fidelity,
    );
  }

  /// ## Sketch
  ///
  /// This service offers an ideal solution for design projects that require
  /// brainstorming and frequent iterations. It upgrades rough hand-drawn
  /// sketches to refined outputs with precise control. For non-sketch images,
  /// it allows detailed manipulation of the final appearance by leveraging the
  /// contour lines and edges within the image.
  ///
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Control/paths/~1v2beta~1stable-image~1control~1sketch/post)
  FileHandler sketch({
    required FileFrom image,
    required String prompt,
    double? controlStrength,
    String? negativePrompt,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
  }) {
    return _req(
      image: image,
      prompt: prompt,
      p: "sketch",
      controlStrength: controlStrength,
      negativePrompt: negativePrompt,
      outputFormat: outputFormat,
      seed: seed,
    );
  }
}
