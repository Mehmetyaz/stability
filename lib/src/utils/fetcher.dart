part of '../stability_base.dart';

class FileHandler {
  FileHandler._(this._responseHandler);

  final _StreamResponseHandler _responseHandler;

  Future<void> writeToFile(String path) async {
    try {
      return _responseHandler.writeToFile(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> readBytes() async {
    try {
      return _responseHandler.readBytes();
    } catch (e) {
      rethrow;
    }
  }

  Future<(int seed, FinishReason finishReason)> readHeaders() async {
    try {
      final headers = await _responseHandler._response.then((e) => e.headers);
      final seed = int.parse(headers['seed']!);
      final finishReason = FinishReason.fromValue(headers['finish_reason']!);

      return (seed, finishReason);
    } catch (e) {
      rethrow;
    }
  }
}

class _StreamResponseHandler {
  _StreamResponseHandler(this._response);

  final Future<StreamedResponse> _response;

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
    try {
      try {
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
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> readBytes() async {
    try {
      await _throwIfNotOk();

      final response = await _response;
      return response.stream.toBytes();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> readAsString() async {
    try {
      return utf8.decode(await readBytes());
    } catch (e) {
      rethrow;
    }
  }

  Future<T> readAsJson<T>() async {
    try {
      final body = await readAsString();
      return jsonDecode(body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> writeToFile(String path) async {
    try {
      final file = File(path);
      await _throwIfNotOk();
      final response = await _response;
      return response.stream.pipe(file.openWrite());
    } catch (e) {
      rethrow;
    }
  }
}

class _StabilityFetcher {
  _StabilityFetcher();

  final Map<String, String> _defaultHeaders = {};

  Uri _uri(_PathSegment from, String path, {Map<String, String>? query}) {
    return Uri.parse(from._buildPath() + path).replace(queryParameters: query);
  }

  _StreamResponseHandler _multipartRequest(
      _PathSegment from, String path, String method,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      Map<String, String>? query}) {
    try {
      final request = MultipartRequest(method, _uri(from, path, query: query));

      body.forEach((key, value) {
        if (value is MultipartFile) {
          request.files.add(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      request.headers.addAll({
        ..._defaultHeaders,
        ...headers ?? {},
      });

      return _StreamResponseHandler(request.send());
    } catch (e) {
      rethrow;
    }
  }

  _StreamResponseHandler _jsonRequest(
      _PathSegment from, String path, String method,
      {required Map<String, dynamic>? body,
      Map<String, String>? headers,
      Map<String, String>? query}) {
    try {
      final req = StreamedRequest(method, _uri(from, path, query: query));

      req.headers.addAll({
        ..._defaultHeaders,
        "Content-Type": "application/json",
        ...headers ?? {},
      });

      if (body != null) {
        final bodyString = jsonEncode(body);
        final encoded = utf8.encode(bodyString);
        final contentLength = encoded.length;

        req.contentLength = contentLength;
        req.sink.add(encoded);
      }

      req.sink.close();

      return _StreamResponseHandler(req.send());
    } catch (e) {
      rethrow;
    }
  }
}
