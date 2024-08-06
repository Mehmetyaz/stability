

enum Method {
  get,
  post,
  put,
  delete;

  String get value {
    return name.toUpperCase();
  }
}

class StabilityError {
  final int status;
  final String statusText;
  final Map<String,dynamic> body;

  StabilityError({
    required this.status,
    required this.statusText,
    required this.body,
  });
}