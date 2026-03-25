import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class HttpFetchResult {
  const HttpFetchResult({
    required this.statusCode,
    required this.bodyBytes,
  });

  final int statusCode;
  final List<int> bodyBytes;

  String get bodyText => utf8.decode(bodyBytes);
}

Future<HttpFetchResult> postBinary(String url, List<int> bytes) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers.contentType = ContentType.binary;
    request.add(bytes);
    final response = await request.close();
    final bodyBytes = await _readAllBytes(response);
    return HttpFetchResult(
      statusCode: response.statusCode,
      bodyBytes: bodyBytes,
    );
  } finally {
    client.close(force: true);
  }
}

Future<HttpFetchResult> getBinary(String url) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final bodyBytes = await _readAllBytes(response);
    return HttpFetchResult(
      statusCode: response.statusCode,
      bodyBytes: bodyBytes,
    );
  } finally {
    client.close(force: true);
  }
}

Future<List<int>> _readAllBytes(HttpClientResponse response) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in response) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}
