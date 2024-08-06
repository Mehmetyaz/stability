part of '../stability_base.dart';

/// The type of the engine.
enum EngineType {
  /// An audio engine.
  audio("AUDIO"),

  /// A video engine.
  video("VIDEO"),

  /// A picture engine.
  picture("PICTURE"),

  /// A text engine.
  text("TEXT"),

  /// A storage engine.
  storage("STORAGE"),

  /// A classification engine.
  classification("CLASSIFICATION");

  /// The value of the engine type.
  const EngineType(this.value);

  /// The value of the engine type.
  final String value;

  /// Returns the engine type from the provided value.
  static EngineType fromValue(String value) {
    return EngineType.values.firstWhere((e) => e.value == value);
  }
}

/// An engine.
class Engine {
  /// The ID of the engine.
  final String id;

  /// The name of the engine.
  final String name;

  /// The description of the engine.
  final String description;

  /// The type of the engine.
  final EngineType type;

  /// Creates a new [Engine] instance.
  Engine.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        type = EngineType.fromValue(json['type'] as String);
}

/// Enumerate engines that work with 'Version 1' REST API endpoints.
///
/// [Read More](https://platform.stability.ai/docs/api-reference#tag/Engines)
class EngineModule with _PathSegment {
  EngineModule._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "v1/engines";

  /// ## List engines
  ///
  /// List all engines available to your organization/user
  ///
  /// [Read More](https://platform.stability.ai/docs/api-reference#tag/Engines/operation/listEngines)
  Future<List<Engine>> list() async {
    final response = await _fetcher
        ._jsonRequest(this, "/list", "GET", body: null)
        .readAsJson<List>();
    return response
        .map((e) => Engine.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
