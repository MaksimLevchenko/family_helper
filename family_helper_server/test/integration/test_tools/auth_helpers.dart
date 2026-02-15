import 'package:serverpod/serverpod.dart';

import 'serverpod_test_tools.dart';

const String user1Id = '00000000-0000-4000-8000-000000000001';
const String user2Id = '00000000-0000-4000-8000-000000000002';

TestSessionBuilder authenticatedBuilder(
  TestSessionBuilder base,
  String userId,
) {
  return base.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      userId,
      <Scope>{},
      authId: userId,
    ),
  );
}

Future<T> withDbSession<T>(
  TestSessionBuilder builder,
  Future<T> Function(Session session) body,
) async {
  final session = builder.build();
  try {
    return await body(session);
  } finally {
    await session.close();
  }
}
