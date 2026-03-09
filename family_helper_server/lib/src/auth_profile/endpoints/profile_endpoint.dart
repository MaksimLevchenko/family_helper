import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/profile_service.dart';

class ProfileEndpoint extends Endpoint {
  ProfileEndpoint({ProfileService? service}) : service = service ?? ProfileService();

  final ProfileService service;

  Future<ProfileDto> me(Session session) {
    return service.getMyProfile(session);
  }

  Future<ProfileDto> update(
    Session session, {
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool clearAvatarMedia = false,
    bool? analyticsOptIn,
  }) {
    return service.updateMyProfile(
      session,
      clientOperationId: clientOperationId,
      displayName: displayName,
      timezone: timezone,
      avatarMediaId: avatarMediaId,
      clearAvatarMedia: clearAvatarMedia,
      analyticsOptIn: analyticsOptIn,
    );
  }
}
