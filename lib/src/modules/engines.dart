part of '../stability_base.dart';

enum EngineType {
  audio("AUDIO"),
  video("VIDEO"),
  picture("PICTURE"),
  text("TEXT"),
  storage("STORAGE"),
  classification("CLASSIFICATION");

  const EngineType(this.value);

  final String value;

  static EngineType fromValue(String value) {
    return EngineType.values.firstWhere((e) => e.value == value);
  }
}

class Engine {
  final String id;
  final String name;
  final String description;
  final EngineType type;

  Engine.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        type = EngineType.fromValue(json['type'] as String);
}

class EngineModule with _PathSegment {
  EngineModule(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "v1/engines";

  Future<List<Engine>> list() async {
    final response = await _fetcher
        ._jsonRequest(this, "/list", "GET", body: null)
        .readAsJson<List>();
    return response
        .map((e) => Engine.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
