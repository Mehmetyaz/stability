part of '../../stability_base.dart';

/// Stable Image v2beta API
class StableImageModule with _PathSegment {
  StableImageModule._(this._parent);

  @override
  final _PathSegment? _parent;

  @override
  String get _path => "v2beta/stable-image";

  /// Tools for editing your existing images.
  StableImageEdit get edit => StableImageEdit._(this);

  /// Tools for increasing the size of your existing images.
  StableImageUpscale get upscale => StableImageUpscale._(this);

  /// Tools for generating precise, controlled variations of existing images or sketches.
  StableImageControl get control => StableImageControl._(this);

  /// Tools for generating new images or variations of existing images.
  StableImageGenerate get generate => StableImageGenerate._(this);
}
