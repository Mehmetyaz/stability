part of '../../stability_base.dart';

/// Tools for editing your existing images.
class StableImageEdit with _PathSegment {
  StableImageEdit._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "edit";

  // all possible parameters
  FileHandler _req({
    required FileFrom image,
    String? prompt,
    String? searchPrompt,
    FileFrom? mask,
    int? growMask,
    int? seed,
    OutputFormat? outputFormat,
    String? negativePrompt,
    int? left,
    int? right,
    int? up,
    int? down,
    double? creativity,
    required String p,
  }) {
    ensureRange(growMask, 0, 20, "grow_mask");
    ensureMin(seed, 0, "seed");
    ensureRange(left, 0, 2000, "left");
    ensureRange(right, 0, 2000, "right");
    ensureRange(up, 0, 2000, "up");
    ensureRange(down, 0, 2000, "down");
    ensureRange(creativity, 0, 1, "creativity");

    final body = {
      "image": image.toMultipartFile("image"),
      if (prompt != null) "prompt": prompt,
      if (searchPrompt != null) "search_prompt": searchPrompt,
      if (mask != null) "mask": mask.toMultipartFile("mask"),
      if (growMask != null) "grow_mask": growMask,
      if (seed != null) "seed": seed,
      if (outputFormat != null) "output_format": outputFormat.name,
      if (negativePrompt != null) "negative_prompt": negativePrompt,
      if (left != null) "left": left,
      if (right != null) "right": right,
      if (up != null) "up": up,
      if (down != null) "down": down,
      if (creativity != null) "creativity": creativity,
    };

    return FileHandler._(
        _fetcher._multipartRequest(this, "/$p", "POST", body: body, headers: {
      "Accept": "image/*",
    }));
  }

  /// ## Erase
  ///
  /// The Erase service removes unwanted objects, such as blemishes on
  /// portraits or items on desks, using image masks.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1erase/post)
  FileHandler erase({
    required FileFrom image,
    FileFrom? mask,
    int? growMask,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
  }) {
    return _req(
      image: image,
      mask: mask,
      growMask: growMask,
      seed: seed,
      outputFormat: outputFormat,
      p: "erase",
    );
  }

  /// ## Inpaint
  ///
  /// Intelligently modify images by filling in or replacing specified areas
  /// with new content based on the content of a "mask" image.
  ///
  /// The "mask" is provided in one of two ways:
  ///
  /// Explicitly passing in a separate image via the mask parameter
  /// Derived from the alpha channel of the image parameter.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1inpaint/post)
  FileHandler inpaint({
    required FileFrom image,
    required String prompt,
    FileFrom? mask,
    int? growMask,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
    String? negativePrompt,
  }) {
    return _req(
      image: image,
      prompt: prompt,
      mask: mask,
      growMask: growMask,
      seed: seed,
      outputFormat: outputFormat,
      negativePrompt: negativePrompt,
      p: "inpaint",
    );
  }

  /// ## Outpaint
  ///
  ///
  /// The Outpaint service inserts additional content in an image to fill in
  /// the space in any direction. Compared to other automated or manual
  /// attempts to expand the content in an image, the Outpaint service should
  /// minimize artifacts and signs that the original image has been edited.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1outpaint/post)
  FileHandler outpaint({
    required FileFrom image,
    int? left,
    int? right,
    int? up,
    int? down,
    double? creativity,
    String? prompt,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
  }) {
    return _req(
      image: image,
      left: left,
      right: right,
      up: up,
      down: down,
      creativity: creativity,
      prompt: prompt,
      seed: seed,
      outputFormat: outputFormat,
      p: "outpaint",
    );
  }

  /// ## Search and Replace
  ///
  /// The Search and Replace service is a specific version of inpainting that
  /// does not require a mask. Instead, users can leverage a search_prompt to
  /// identify an object in simple language to be replaced. The service will
  /// automatically segment the object and replace it with the object requested
  /// in the prompt.
  ///
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1search-and-replace/post)
  FileHandler searchAndReplace({
    required FileFrom image,
    required String prompt,
    required String searchPrompt,
    int? growMask,
    int? seed,
    OutputFormat outputFormat = OutputFormat.png,
    String? negativePrompt,
  }) {
    return _req(
      image: image,
      prompt: prompt,
      searchPrompt: searchPrompt,
      growMask: growMask,
      seed: seed,
      outputFormat: outputFormat,
      negativePrompt: negativePrompt,
      p: "search-and-replace",
    );
  }

  /// ## Remove Background
  ///
  /// The Remove Background service accurately segments the foreground from an
  /// image and implements and removes the background.
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1remove-background/post)
  FileHandler removeBackground({
    required FileFrom image,
    OutputFormat outputFormat = OutputFormat.png,
  }) {
    return _req(
      image: image,
      outputFormat: outputFormat,
      p: "remove-background",
    );
  }
}
