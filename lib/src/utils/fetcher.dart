part of '../stability_base.dart';

class StreamResponseHandler {
  StreamResponseHandler(this._response);

  final Future<http.StreamedResponse> _response;

  Future<void> _throwIfNotOk() async {
    final response = await _response;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StabilityError(
          status: response.statusCode,
          statusText: response.reasonPhrase ?? "unknown",
          body: await _asJson());
    }
  }

  Future<Map<String, dynamic>> _asJson() async {
    final response = await _response;
    try {
      final body = await response.stream.bytesToString();
      return jsonDecode(body);
    } catch (e) {
      throw StabilityError(
          status: response.statusCode,
          statusText: response.reasonPhrase ?? "unknown",
          body: {
            "error": "Failed to parse response as JSON",
            "message": e.toString(),
          });
    }
  }

  Future<Uint8List> readBytes() async {
    _throwIfNotOk();

    final response = await _response;

    final res = await response.stream.toBytes();

    return res;
  }

  Future<String> readAsString() async {
    return utf8.decode(await readBytes());
  }

  Future<T> readAsJson<T>() async {
    final body = await readAsString();
    return jsonDecode(body);
  }

  Future<void> writeToFile(String path) async {
    final file = File(path);
    _throwIfNotOk();
    final response = await _response;
    return response.stream.pipe(file.openWrite());
  }
}

class _StabilityFetcher {
  _StabilityFetcher();

  final Map<String, String> _defaultHeaders = {};

  Uri _uri(_PathSegment from, String path ,{Map<String, String>? query}) {
    return Uri.parse(from._buildPath() + path).replace(queryParameters: query);
  }

  StreamResponseHandler _multipartRequest(
      _PathSegment from, String path, String method,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      Map<String, String>? query})  {
    final request = http.MultipartRequest(method, _uri(from, path, query: query));

    body.forEach((key, value) {
      if (value is http.MultipartFile) {
        request.files.add(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    request.headers.addAll({
      ..._defaultHeaders,
      ...headers ?? {},
    });

    return StreamResponseHandler(request.send());
  }

  StreamResponseHandler _jsonRequest(_PathSegment from, String path, String method,
      {required Map<String, dynamic>? body,
      Map<String, String>? headers,
      Map<String, String>? query})  {
    final req = http.StreamedRequest(method, _uri(from, path, query: query));

    req.headers.addAll({
      ..._defaultHeaders,
      ...headers ?? {},
    });

    if (body != null) {
      final bodyString = jsonEncode(body);
      final bodyStream =
          http.ByteStream(Stream.fromIterable([utf8.encode(bodyString)]));
      final contentLength = utf8.encode(bodyString).length;

      req.contentLength = contentLength;
      req.sink.addStream(bodyStream);
    }

    return StreamResponseHandler(req.send());
  }

}
