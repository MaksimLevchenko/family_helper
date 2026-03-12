import 'package:family_helper_flutter/core/network/server_url_resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerUrlResolver.normalize', () {
    test('rewrites localhost to Android emulator loopback in debug', () {
      final resolved = ServerUrlResolver.normalize(
        'http://localhost:8080/',
        platform: TargetPlatform.android,
      );

      expect(resolved, 'http://10.0.2.2:8080/');
    });

    test('rewrites 127.0.0.1 to Android emulator loopback in debug', () {
      final resolved = ServerUrlResolver.normalize(
        'http://127.0.0.1:8080/',
        platform: TargetPlatform.android,
      );

      expect(resolved, 'http://10.0.2.2:8080/');
    });

    test('keeps custom server ip untouched on Android', () {
      final resolved = ServerUrlResolver.normalize(
        'http://192.168.0.15:8080/',
        platform: TargetPlatform.android,
      );

      expect(resolved, 'http://192.168.0.15:8080/');
    });

    test('keeps localhost unchanged outside Android emulator flow', () {
      final resolved = ServerUrlResolver.normalize(
        'http://localhost:8080/',
        platform: TargetPlatform.iOS,
      );

      expect(resolved, 'http://localhost:8080/');
    });
  });
}
