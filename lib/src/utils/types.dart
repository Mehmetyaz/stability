enum ResolveType {
  json,
  text,
  bytes,
}

enum Method {
  get,
  post,
  put,
  delete,
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