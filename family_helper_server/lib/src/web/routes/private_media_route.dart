import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../core/storage/private_media_storage_service.dart';

class PrivateMediaRoute extends Route {
  PrivateMediaRoute({PrivateMediaStorageService? storage})
    : storage = storage ?? PrivateMediaStorageService(),
      super(methods: {Method.get, Method.head, Method.options});

  final PrivateMediaStorageService storage;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    try {
      if (request.method == Method.options) {
        return Response.ok(headers: _corsHeaders());
      }

      final resolvedStorage = storage.forSession(session);
      final validation = resolvedStorage.validateSignedDownloadUri(request.url);

      if (!validation.isValid) {
        final error = validation.error;
        if (error == SignedDownloadValidationError.expired) {
          return _withCors(
            Response(
              410,
              body: Body.fromString('Signed media URL has expired.'),
            ),
          );
        }

        return _withCors(
          Response.forbidden(
            body: Body.fromString('Signed media URL is invalid.'),
          ),
        );
      }

      final payload = validation.payload!;
      final byteData = await resolvedStorage.retrieveBytes(
        session,
        path: payload.path,
      );
      if (byteData == null) {
        return _withCors(
          Response.notFound(body: Body.fromString('Private media not found.')),
        );
      }

      final mimeType = _parseMimeType(payload.mimeType);
      return _withCors(
        Response.ok(
          body: Body.fromData(
            Uint8List.sublistView(byteData),
            mimeType: mimeType,
          ),
        ),
      );
    } catch (error, stackTrace) {
      session.log(
        'private-media route failed; method=${request.method.name}; url=${request.url}',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      return _withCors(
        Response(
          500,
          body: Body.fromString('Private media could not be served.'),
        ),
      );
    }
  }

  Response _withCors(Response response) {
    return response.copyWith(
      headers: response.headers.isEmpty
          ? _corsHeaders()
          : response.headers.transform((headers) {
              for (final entry in _corsHeaders().entries) {
                headers[entry.key] = entry.value;
              }
            }),
    );
  }

  Headers _corsHeaders() {
    return Headers.build((headers) {
      headers['Access-Control-Allow-Origin'] = ['*'];
      headers['Access-Control-Allow-Methods'] = ['GET, HEAD, OPTIONS'];
      headers['Access-Control-Allow-Headers'] = ['Content-Type'];
      headers['Cross-Origin-Resource-Policy'] = ['cross-origin'];
    });
  }

  MimeType _parseMimeType(String value) {
    try {
      return MimeType.parse(value);
    } on FormatException {
      return MimeType.octetStream;
    }
  }
}
