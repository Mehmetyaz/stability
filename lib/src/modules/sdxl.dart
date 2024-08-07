part of '../stability_base.dart';

///To preserve only roughly 35% of the initial image, pass in either
///init_image_mode=IMAGE_STRENGTH and image_strength=0.35 or
///init_image_mode=STEP_SCHEDULE and step_schedule_start=0.65. Both of these
///are equivalent, however init_image_mode=STEP_SCHEDULE also lets you pass
/// in step_schedule_end, which can provide an extra level of control for those
/// who need it. For more details, see the specific fields below.
abstract class InitImageMode {
  Map<String, dynamic> _toJson();

  /// Use image_strength as image_init_mode
  static ImageStrength imageStrength({double? imageStrength}) {
    return ImageStrength._(imageStrength);
  }

  /// Use step_schedule as image_init_mode
  static StepSchedule stepSchedule({double? start, double? end}) {
    return StepSchedule._(start, end);
  }
}

/// Use image_strength as image_init_mode
class ImageStrength implements InitImageMode {
  final double? imageStrength;

  ImageStrength._([this.imageStrength]);

  @override
  Map<String, dynamic> _toJson() {
    return {
      "init_image_mode": "IMAGE_STRENGTH",
      if (imageStrength != null) "image_strength": imageStrength
    };
  }
}

/// Use step_schedule as image_init_mode
class StepSchedule extends InitImageMode {
  StepSchedule._(this.start, this.end);

  /// step_schedule_start & step_schedule_end values of the step schedule
  final double? start, end;

  @override
  Map<String, dynamic> _toJson() {
    return {
      "init_image_mode": "STEP_SCHEDULE",
      if (start != null) "step_schedule_start": start,
      if (end != null) "step_schedule_end": end
    };
  }
}

/// The source of the mask image.
abstract class MaskSource {
  Map<String, dynamic> _toJson();

  /// Use MASK_IMAGE_WHITE as mask_source
  static MaskWhite white({required FileFrom file}) {
    return MaskWhite._(file);
  }

  /// Use MASK_IMAGE_BLACK as mask_source
  static MaskBlack black({required FileFrom file}) {
    return MaskBlack._(file);
  }

  /// Use INIT_IMAGE_ALPHA as mask_source
  static InitImageAlpha initImageAlpha() {
    return InitImageAlpha._();
  }
}

/// Use MASK_IMAGE_WHITE as mask_source
class MaskWhite implements MaskSource {
  /// MASK_IMAGE_WHITE requires a mask image
  final FileFrom file;

  MaskWhite._(this.file);

  @override
  Map<String, dynamic> _toJson() {
    return {
      "mask_image": file.toMultipartFile("mask"),
      "mask_source": "MASK_IMAGE_WHITE",
    };
  }
}

/// Use MASK_IMAGE_BLACK as mask_source
class MaskBlack implements MaskSource {
  /// MASK_IMAGE_BLACK requires a mask image
  final FileFrom file;

  MaskBlack._(this.file);

  @override
  Map<String, dynamic> _toJson() {
    return {
      "mask_image": file.toMultipartFile("mask"),
      "mask_source": "MASK_IMAGE_BLACK",
    };
  }
}

/// Use INIT_IMAGE_ALPHA as mask_source
class InitImageAlpha extends MaskSource {
  InitImageAlpha._();

  @override
  Map<String, dynamic> _toJson() {
    return {
      "mask_source": "INIT_IMAGE_ALPHA",
    };
  }
}

/// Prompt for the sdxl module.
class Prompt {
  /// The text of the prompt.
  final String text;

  /// The weight of the prompt. The default is 1.0.
  final double? weight;

  Prompt(this.text, [this.weight]);
}

/// The SDXL module.
///
///
class SDXLModule with _PathSegment {
  SDXLModule._(this._parent, this._engine);

  @override
  final _PathSegment _parent;

  final String _engine;

  @override
  String get _path => "v1/generation/$_engine";

  /// https://platform.stability.ai/docs/api-reference#tag/SDXL-and-SD1.6/operation/textToImage
  Future<List<({Base64File image, FinishReason finishReason, int seed})>>
      textToImage({
    required List<Prompt> prompts,
    int? height,
    int? width,
    int? cfgScale,
    ClipGuidancePreset? clipGuidancePreset,
    Sampler? sampler,
    int? samples,
    int? seed,
    int? steps,
    Map<String, dynamic>? extras,
    StylePreset? stylePreset,
  }) async {
    ensureMin(height, 128, "height");
    ensureMin(width, 128, "width");
    ensureDivisibleBy(height, 64, "height");
    ensureDivisibleBy(width, 64, "width");
    ensureRange(cfgScale, 0, 35, "cfg_scale");
    ensureRange(samples, 1, 10, "samples");
    ensureMin(seed, 0, "seed");
    ensureRange(steps, 10, 50, "steps");

    final body = {
      "text_prompts":
          prompts.map((e) => {"text": e.text, "weight": e.weight}).toList(),
      if (height != null) "height": height,
      if (width != null) "width": width,
      if (cfgScale != null) "cfg_scale": cfgScale,
      if (clipGuidancePreset != null)
        "clip_guidance_preset": clipGuidancePreset.value,
      if (sampler != null) "sampler": sampler.value,
      if (samples != null) "samples": samples,
      if (seed != null) "seed": seed,
      if (steps != null) "steps": steps,
      if (extras != null) "extras": extras,
      if (stylePreset != null) "style_preset": stylePreset.value,
    };

    final res = await _fetcher._jsonRequest(this, "/text-to-image", "POST",
        body: body,
        headers: {
          "Accept": "application/json"
        }).readAsJson<Map<String, dynamic>>();
    return (res["artifacts"] as List).map((e) {
      return (
        image: Base64File(base64: e['base64']),
        finishReason: FinishReason.fromValue(e['finishReason']),
        seed: e['seed'] as int,
      );
    }).toList();
  }

  /// https://platform.stability.ai/docs/api-reference#tag/SDXL-and-SD1.6/operation/imageToImage
  Future<List<({Base64File image, FinishReason finishReason, int seed})>>
      imageToImageWithPrompt({
    required List<Prompt> prompts,
    required FileFrom image,
    InitImageMode? initImageMode,
    double? cfgScale,
    ClipGuidancePreset? clipGuidancePreset,
    Sampler? sampler,
    int? samples,
    int? seed,
    int? steps,
    Map<String, dynamic>? extras,
    StylePreset? stylePreset,
  }) {
    ensureRange(samples, 1, 10, "samples");
    ensureMin(seed, 0, "seed");
    ensureRange(steps, 10, 50, "steps");
    ensureCfgScale(cfgScale);

    final body = {
      for (var i = 0; i < prompts.length; i++)
        "text_prompts[$i][text]": prompts[i].text,
      for (var i = 0; i < prompts.length; i++)
        if (prompts[i].weight != null)
          "text_prompts[$i][weight]": prompts[i].weight,
      "init_image": image.toMultipartFile("image"),
      if (initImageMode != null) ...initImageMode._toJson(),
      if (cfgScale != null) "cfg_scale": cfgScale,
      if (clipGuidancePreset != null)
        "clip_guidance_preset": clipGuidancePreset.value,
      if (sampler != null) "sampler": sampler.value,
      if (samples != null) "samples": samples,
      if (seed != null) "seed": seed,
      if (steps != null) "steps": steps,
      if (extras != null) "extras": extras,
      if (stylePreset != null) "style_preset": stylePreset.value,
    };

    return _fetcher
        ._multipartRequest(this, "/image-to-image", "POST",
            body: body, headers: {"Accept": "application/json"})
        .readAsJson<Map<String, dynamic>>()
        .then((e) => (e["artifacts"] as List)
            .map((e) => (
                  image: Base64File(base64: e['base64']),
                  finishReason: FinishReason.fromValue(e['finishReason']),
                  seed: e['seed'] as int,
                ))
            .toList());
  }

  /// https://platform.stability.ai/docs/api-reference#tag/SDXL-and-SD1.6/operation/upscaleImage
  FileHandler upscale(
    FileFrom image, {
    int? height,
    int? width,
  }) {
    ensureMin(height, 512, "height");
    ensureMin(width, 512, "width");

    final body = {
      "image": image.toMultipartFile("image"),
      if (height != null) "height": height,
      if (width != null) "width": width,
    };

    return FileHandler._(_fetcher._multipartRequest(
        _parent, "/esrgan-v1-x2plus/image-to-image/upscale", "POST",
        body: body, headers: {"Accept": "application/json"}));
  }
}

/// https://platform.stability.ai/docs/api-reference#tag/SDXL-and-SD1.6/operation/masking
class SDXLWithMaskModule extends SDXLModule {
  SDXLWithMaskModule._(super._parent, super._engine) : super._();

  /// https://platform.stability.ai/docs/api-reference#tag/SDXL-and-SD1.6/operation/masking
  Future<List<({Base64File image, FinishReason finishReason, int seed})>>
      imageToImageWithMask({
    required List<Prompt> prompts,
    required FileFrom image,
    required MaskSource maskSource,
    int? cfgScale,
    ClipGuidancePreset? clipGuidancePreset,
    Sampler? sampler,
    int? samples,
    int? seed,
    int? steps,
    Map<String, dynamic>? extras,
    StylePreset? stylePreset,
  }) {
    ensureRange(samples, 1, 10, "samples");
    ensureMin(seed, 0, "seed");
    ensureRange(steps, 10, 50, "steps");

    final body = {
      for (var i = 0; i < prompts.length; i++)
        "text_prompts[$i][text]": prompts[i].text,
      for (var i = 0; i < prompts.length; i++)
        if (prompts[i].weight != null)
          "text_prompts[$i][weight]": prompts[i].weight,
      "init_image": image.toMultipartFile("image"),
      ...maskSource._toJson(),
      if (cfgScale != null) "cfg_scale": cfgScale,
      if (clipGuidancePreset != null)
        "clip_guidance_preset": clipGuidancePreset.value,
      if (sampler != null) "sampler": sampler.value,
      if (samples != null) "samples": samples,
      if (seed != null) "seed": seed,
      if (steps != null) "steps": steps,
      if (extras != null) "extras": extras,
      if (stylePreset != null) "style_preset": stylePreset.value,
    };

    return _fetcher
        ._multipartRequest(this, "/image-to-image/masking", "POST",
            body: body, headers: {"Accept": "application/json"})
        .readAsJson<Map<String, dynamic>>()
        .then((e) => (e["artifacts"] as List)
            .map((e) => (
                  image: Base64File(base64: e['base64']),
                  finishReason: FinishReason.fromValue(e['finishReason']),
                  seed: e['seed'] as int,
                ))
            .toList());
  }
}
