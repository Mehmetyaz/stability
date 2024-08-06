part of '../stability_base.dart';

class StabilityOrganization {
  final String id;
  final String name;
  final String role;
  final bool isDefault;

  StabilityOrganization.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        role = json['role'],
        isDefault = json['is_default'];
}

class StabilityUser {
  final String id;
  final String email;
  final List<StabilityOrganization> organizations;
  final String? profilePicture;

  StabilityUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        organizations = (json['organizations'] as List)
            .map((e) =>
                StabilityOrganization.fromJson(e as Map<String, dynamic>))
            .toList(),
        profilePicture = json['profile_picture'];
}

class UserModule with _PathSegment {
  UserModule(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "v1/user";

  Future<StabilityUser> account() {
    return _fetcher
        ._jsonRequest(this, "/account", "GET", body: null)
        .readAsJson<Map<String, dynamic>>()
        .then((e) => StabilityUser.fromJson(e));
  }

  Future<double> balance() async {
    final res = await _fetcher
        ._jsonRequest(this, "/balance", "GET", body: null)
        .readAsJson<Map<String, dynamic>>();

    return res['credits'];
  }
}
