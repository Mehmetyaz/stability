part of '../stability_base.dart';

/// A Stability AI organization.
class StabilityOrganization {
  /// The ID of the organization.
  final String id;

  /// The name of the organization.
  final String name;

  /// The role of the user in the organization.
  final String role;

  /// Whether the organization is the default organization for the user.
  final bool isDefault;

  /// Creates a new [StabilityOrganization] instance.
  StabilityOrganization.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        role = json['role'],
        isDefault = json['is_default'];
}

/// A Stability AI user.
class StabilityUser {
  /// The ID of the user.
  final String id;

  /// The email of the user.
  final String email;

  /// The organizations the user is a part of.
  final List<StabilityOrganization> organizations;

  /// The profile picture of the user.
  final String? profilePicture;

  /// Creates a new [StabilityUser] instance.
  StabilityUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        organizations = (json['organizations'] as List)
            .map((e) =>
                StabilityOrganization.fromJson(e as Map<String, dynamic>))
            .toList(),
        profilePicture = json['profile_picture'];
}

/// A module for interacting with the user API.
///
/// See: [User API](https://platform.stability.ai/docs/api-reference#tag/User)
class UserModule with _PathSegment {
  UserModule._(this._parent);

  @override
  final _PathSegment _parent;

  @override
  String get _path => "v1/user";

  /// Fetches the account details of the user.
  ///
  Future<StabilityUser> account() {
    return _fetcher
        ._jsonRequest(this, "/account", "GET", body: null)
        .readAsJson<Map<String, dynamic>>()
        .then((e) => StabilityUser.fromJson(e));
  }

  /// Fetches the balance of the user.
  Future<double> balance() async {
    final res = await _fetcher
        ._jsonRequest(this, "/balance", "GET", body: null)
        .readAsJson<Map<String, dynamic>>();

    return res['credits'];
  }
}
