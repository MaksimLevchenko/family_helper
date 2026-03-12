/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../auth_profile/endpoints/profile_endpoint.dart' as _i4;
import '../calendar/endpoints/calendar_endpoint.dart' as _i5;
import '../family/endpoints/family_endpoint.dart' as _i6;
import '../greetings/greeting_endpoint.dart' as _i7;
import '../lists/endpoints/lists_endpoint.dart' as _i8;
import '../media/endpoints/media_endpoint.dart' as _i9;
import '../money_goals/endpoints/money_goals_endpoint.dart' as _i10;
import '../notifications/endpoints/notifications_endpoint.dart' as _i11;
import '../privacy/endpoints/privacy_endpoint.dart' as _i12;
import '../realtime/endpoints/realtime_endpoint.dart' as _i13;
import '../sync/endpoints/sync_endpoint.dart' as _i14;
import '../tasks/endpoints/tasks_endpoint.dart' as _i15;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i16;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i17;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'profile': _i4.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'calendar': _i5.CalendarEndpoint()
        ..initialize(
          server,
          'calendar',
          null,
        ),
      'family': _i6.FamilyEndpoint()
        ..initialize(
          server,
          'family',
          null,
        ),
      'greeting': _i7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'lists': _i8.ListsEndpoint()
        ..initialize(
          server,
          'lists',
          null,
        ),
      'media': _i9.MediaEndpoint()
        ..initialize(
          server,
          'media',
          null,
        ),
      'moneyGoals': _i10.MoneyGoalsEndpoint()
        ..initialize(
          server,
          'moneyGoals',
          null,
        ),
      'notifications': _i11.NotificationsEndpoint()
        ..initialize(
          server,
          'notifications',
          null,
        ),
      'privacy': _i12.PrivacyEndpoint()
        ..initialize(
          server,
          'privacy',
          null,
        ),
      'realtime': _i13.RealtimeEndpoint()
        ..initialize(
          server,
          'realtime',
          null,
        ),
      'sync': _i14.SyncEndpoint()
        ..initialize(
          server,
          'sync',
          null,
        ),
      'tasks': _i15.TasksEndpoint()
        ..initialize(
          server,
          'tasks',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['profile'] = _i1.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'me': _i1.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i4.ProfileEndpoint).me(session),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'displayName': _i1.ParameterDescription(
              name: 'displayName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'timezone': _i1.ParameterDescription(
              name: 'timezone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'avatarMediaId': _i1.ParameterDescription(
              name: 'avatarMediaId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'clearAvatarMedia': _i1.ParameterDescription(
              name: 'clearAvatarMedia',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'analyticsOptIn': _i1.ParameterDescription(
              name: 'analyticsOptIn',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i4.ProfileEndpoint).update(
                session,
                clientOperationId: params['clientOperationId'],
                displayName: params['displayName'],
                timezone: params['timezone'],
                avatarMediaId: params['avatarMediaId'],
                clearAvatarMedia: params['clearAvatarMedia'],
                analyticsOptIn: params['analyticsOptIn'],
              ),
        ),
      },
    );
    connectors['calendar'] = _i1.EndpointConnector(
      name: 'calendar',
      endpoint: endpoints['calendar']!,
      methodConnectors: {
        'upsertEvent': _i1.MethodConnector(
          name: 'upsertEvent',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'startsAt': _i1.ParameterDescription(
              name: 'startsAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endsAt': _i1.ParameterDescription(
              name: 'endsAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'timezone': _i1.ParameterDescription(
              name: 'timezone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'rrule': _i1.ParameterDescription(
              name: 'rrule',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'colorKey': _i1.ParameterDescription(
              name: 'colorKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['calendar'] as _i5.CalendarEndpoint).upsertEvent(
                    session,
                    clientOperationId: params['clientOperationId'],
                    eventId: params['eventId'],
                    familyId: params['familyId'],
                    title: params['title'],
                    description: params['description'],
                    startsAt: params['startsAt'],
                    endsAt: params['endsAt'],
                    timezone: params['timezone'],
                    rrule: params['rrule'],
                    colorKey: params['colorKey'],
                    category: params['category'],
                  ),
        ),
        'upsertOverride': _i1.MethodConnector(
          name: 'upsertOverride',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'occurrenceStart': _i1.ParameterDescription(
              name: 'occurrenceStart',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'scope': _i1.ParameterDescription(
              name: 'scope',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'overrideTitle': _i1.ParameterDescription(
              name: 'overrideTitle',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'overrideStartsAt': _i1.ParameterDescription(
              name: 'overrideStartsAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'overrideEndsAt': _i1.ParameterDescription(
              name: 'overrideEndsAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'cancelled': _i1.ParameterDescription(
              name: 'cancelled',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i5.CalendarEndpoint)
                  .upsertOverride(
                    session,
                    clientOperationId: params['clientOperationId'],
                    familyId: params['familyId'],
                    eventId: params['eventId'],
                    occurrenceStart: params['occurrenceStart'],
                    scope: params['scope'],
                    overrideTitle: params['overrideTitle'],
                    overrideStartsAt: params['overrideStartsAt'],
                    overrideEndsAt: params['overrideEndsAt'],
                    cancelled: params['cancelled'],
                  ),
        ),
        'listInstances': _i1.MethodConnector(
          name: 'listInstances',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'rangeStart': _i1.ParameterDescription(
              name: 'rangeStart',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'rangeEnd': _i1.ParameterDescription(
              name: 'rangeEnd',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['calendar'] as _i5.CalendarEndpoint).listInstances(
                    session,
                    familyId: params['familyId'],
                    rangeStart: params['rangeStart'],
                    rangeEnd: params['rangeEnd'],
                  ),
        ),
      },
    );
    connectors['family'] = _i1.EndpointConnector(
      name: 'family',
      endpoint: endpoints['family']!,
      methodConnectors: {
        'createFamily': _i1.MethodConnector(
          name: 'createFamily',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _i6.FamilyEndpoint).createFamily(
                    session,
                    clientOperationId: params['clientOperationId'],
                    title: params['title'],
                  ),
        ),
        'listMembers': _i1.MethodConnector(
          name: 'listMembers',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _i6.FamilyEndpoint).listMembers(
                    session,
                    familyId: params['familyId'],
                  ),
        ),
        'getFamily': _i1.MethodConnector(
          name: 'getFamily',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['family'] as _i6.FamilyEndpoint).getFamily(
                session,
                familyId: params['familyId'],
              ),
        ),
        'createInvite': _i1.MethodConnector(
          name: 'createInvite',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'inviteType': _i1.ParameterDescription(
              name: 'inviteType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _i6.FamilyEndpoint).createInvite(
                    session,
                    familyId: params['familyId'],
                    clientOperationId: params['clientOperationId'],
                    inviteType: params['inviteType'],
                    email: params['email'],
                  ),
        ),
        'acceptInvite': _i1.MethodConnector(
          name: 'acceptInvite',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'tokenOrCode': _i1.ParameterDescription(
              name: 'tokenOrCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _i6.FamilyEndpoint).acceptInvite(
                    session,
                    clientOperationId: params['clientOperationId'],
                    tokenOrCode: params['tokenOrCode'],
                  ),
        ),
        'transferOwnership': _i1.MethodConnector(
          name: 'transferOwnership',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newOwnerProfileId': _i1.ParameterDescription(
              name: 'newOwnerProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _i6.FamilyEndpoint).transferOwnership(
                    session,
                    familyId: params['familyId'],
                    clientOperationId: params['clientOperationId'],
                    newOwnerProfileId: params['newOwnerProfileId'],
                  ),
        ),
        'leaveFamily': _i1.MethodConnector(
          name: 'leaveFamily',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _i6.FamilyEndpoint).leaveFamily(
                    session,
                    familyId: params['familyId'],
                    clientOperationId: params['clientOperationId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i7.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['lists'] = _i1.EndpointConnector(
      name: 'lists',
      endpoint: endpoints['lists']!,
      methodConnectors: {
        'upsertList': _i1.MethodConnector(
          name: 'upsertList',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listType': _i1.ParameterDescription(
              name: 'listType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lists'] as _i8.ListsEndpoint).upsertList(
                session,
                clientOperationId: params['clientOperationId'],
                listId: params['listId'],
                familyId: params['familyId'],
                title: params['title'],
                listType: params['listType'],
              ),
        ),
        'addItem': _i1.MethodConnector(
          name: 'addItem',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'qty': _i1.ParameterDescription(
              name: 'qty',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'unit': _i1.ParameterDescription(
              name: 'unit',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priceCents': _i1.ParameterDescription(
              name: 'priceCents',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lists'] as _i8.ListsEndpoint).addItem(
                session,
                clientOperationId: params['clientOperationId'],
                familyId: params['familyId'],
                listId: params['listId'],
                title: params['title'],
                qty: params['qty'],
                unit: params['unit'],
                note: params['note'],
                priceCents: params['priceCents'],
                category: params['category'],
              ),
        ),
        'toggleBought': _i1.MethodConnector(
          name: 'toggleBought',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'itemId': _i1.ParameterDescription(
              name: 'itemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lists'] as _i8.ListsEndpoint).toggleBought(
                session,
                clientOperationId: params['clientOperationId'],
                familyId: params['familyId'],
                itemId: params['itemId'],
              ),
        ),
        'reorderItems': _i1.MethodConnector(
          name: 'reorderItems',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'orderedItemIds': _i1.ParameterDescription(
              name: 'orderedItemIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lists'] as _i8.ListsEndpoint).reorderItems(
                session,
                clientOperationId: params['clientOperationId'],
                familyId: params['familyId'],
                listId: params['listId'],
                orderedItemIds: params['orderedItemIds'],
              ),
        ),
        'listItems': _i1.MethodConnector(
          name: 'listItems',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lists'] as _i8.ListsEndpoint).listItems(
                session,
                familyId: params['familyId'],
                listId: params['listId'],
              ),
        ),
      },
    );
    connectors['media'] = _i1.EndpointConnector(
      name: 'media',
      endpoint: endpoints['media']!,
      methodConnectors: {
        'createUploadSession': _i1.MethodConnector(
          name: 'createUploadSession',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'mimeType': _i1.ParameterDescription(
              name: 'mimeType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sizeBytes': _i1.ParameterDescription(
              name: 'sizeBytes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'objectPrefix': _i1.ParameterDescription(
              name: 'objectPrefix',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['media'] as _i9.MediaEndpoint).createUploadSession(
                    session,
                    clientOperationId: params['clientOperationId'],
                    familyId: params['familyId'],
                    mimeType: params['mimeType'],
                    sizeBytes: params['sizeBytes'],
                    objectPrefix: params['objectPrefix'],
                  ),
        ),
        'completeUpload': _i1.MethodConnector(
          name: 'completeUpload',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'mediaId': _i1.ParameterDescription(
              name: 'mediaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'thumbnailKey': _i1.ParameterDescription(
              name: 'thumbnailKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['media'] as _i9.MediaEndpoint).completeUpload(
                    session,
                    clientOperationId: params['clientOperationId'],
                    mediaId: params['mediaId'],
                    thumbnailKey: params['thumbnailKey'],
                  ),
        ),
        'signedGetUrl': _i1.MethodConnector(
          name: 'signedGetUrl',
          params: {
            'mediaId': _i1.ParameterDescription(
              name: 'mediaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['media'] as _i9.MediaEndpoint).signedGetUrl(
                session,
                mediaId: params['mediaId'],
              ),
        ),
        'listMedia': _i1.MethodConnector(
          name: 'listMedia',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['media'] as _i9.MediaEndpoint).listMedia(
                session,
                familyId: params['familyId'],
                limit: params['limit'],
              ),
        ),
        'softDelete': _i1.MethodConnector(
          name: 'softDelete',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'mediaId': _i1.ParameterDescription(
              name: 'mediaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['media'] as _i9.MediaEndpoint).softDelete(
                session,
                clientOperationId: params['clientOperationId'],
                mediaId: params['mediaId'],
              ),
        ),
      },
    );
    connectors['moneyGoals'] = _i1.EndpointConnector(
      name: 'moneyGoals',
      endpoint: endpoints['moneyGoals']!,
      methodConnectors: {
        'upsertGoal': _i1.MethodConnector(
          name: 'upsertGoal',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'goalId': _i1.ParameterDescription(
              name: 'goalId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'targetAmountCents': _i1.ParameterDescription(
              name: 'targetAmountCents',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'currency': _i1.ParameterDescription(
              name: 'currency',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deadlineAt': _i1.ParameterDescription(
              name: 'deadlineAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['moneyGoals'] as _i10.MoneyGoalsEndpoint)
                  .upsertGoal(
                    session,
                    clientOperationId: params['clientOperationId'],
                    goalId: params['goalId'],
                    familyId: params['familyId'],
                    title: params['title'],
                    description: params['description'],
                    targetAmountCents: params['targetAmountCents'],
                    currency: params['currency'],
                    deadlineAt: params['deadlineAt'],
                  ),
        ),
        'addContribution': _i1.MethodConnector(
          name: 'addContribution',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'goalId': _i1.ParameterDescription(
              name: 'goalId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'amountCents': _i1.ParameterDescription(
              name: 'amountCents',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'currency': _i1.ParameterDescription(
              name: 'currency',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['moneyGoals'] as _i10.MoneyGoalsEndpoint)
                  .addContribution(
                    session,
                    clientOperationId: params['clientOperationId'],
                    familyId: params['familyId'],
                    goalId: params['goalId'],
                    amountCents: params['amountCents'],
                    currency: params['currency'],
                    note: params['note'],
                  ),
        ),
        'listGoals': _i1.MethodConnector(
          name: 'listGoals',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['moneyGoals'] as _i10.MoneyGoalsEndpoint)
                  .listGoals(
                    session,
                    familyId: params['familyId'],
                  ),
        ),
      },
    );
    connectors['notifications'] = _i1.EndpointConnector(
      name: 'notifications',
      endpoint: endpoints['notifications']!,
      methodConnectors: {
        'registerPushToken': _i1.MethodConnector(
          name: 'registerPushToken',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications'] as _i11.NotificationsEndpoint)
                      .registerPushToken(
                        session,
                        clientOperationId: params['clientOperationId'],
                        token: params['token'],
                        platform: params['platform'],
                      ),
        ),
        'upsertPreference': _i1.MethodConnector(
          name: 'upsertPreference',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationType': _i1.ParameterDescription(
              name: 'notificationType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'enabled': _i1.ParameterDescription(
              name: 'enabled',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'quietHoursStart': _i1.ParameterDescription(
              name: 'quietHoursStart',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'quietHoursEnd': _i1.ParameterDescription(
              name: 'quietHoursEnd',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications'] as _i11.NotificationsEndpoint)
                      .upsertPreference(
                        session,
                        clientOperationId: params['clientOperationId'],
                        notificationType: params['notificationType'],
                        enabled: params['enabled'],
                        quietHoursStart: params['quietHoursStart'],
                        quietHoursEnd: params['quietHoursEnd'],
                      ),
        ),
        'listPreferences': _i1.MethodConnector(
          name: 'listPreferences',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications'] as _i11.NotificationsEndpoint)
                      .listPreferences(session),
        ),
        'scheduleReminder': _i1.MethodConnector(
          name: 'scheduleReminder',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'entityType': _i1.ParameterDescription(
              name: 'entityType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'entityId': _i1.ParameterDescription(
              name: 'entityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'remindAt': _i1.ParameterDescription(
              name: 'remindAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'payloadJson': _i1.ParameterDescription(
              name: 'payloadJson',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications'] as _i11.NotificationsEndpoint)
                      .scheduleReminder(
                        session,
                        clientOperationId: params['clientOperationId'],
                        familyId: params['familyId'],
                        entityType: params['entityType'],
                        entityId: params['entityId'],
                        remindAt: params['remindAt'],
                        payloadJson: params['payloadJson'],
                      ),
        ),
        'listReminders': _i1.MethodConnector(
          name: 'listReminders',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications'] as _i11.NotificationsEndpoint)
                      .listReminders(
                        session,
                        familyId: params['familyId'],
                        status: params['status'],
                        limit: params['limit'],
                      ),
        ),
        'processDueReminders': _i1.MethodConnector(
          name: 'processDueReminders',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications'] as _i11.NotificationsEndpoint)
                      .processDueReminders(session),
        ),
      },
    );
    connectors['privacy'] = _i1.EndpointConnector(
      name: 'privacy',
      endpoint: endpoints['privacy']!,
      methodConnectors: {
        'requestExport': _i1.MethodConnector(
          name: 'requestExport',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privacy'] as _i12.PrivacyEndpoint).requestExport(
                    session,
                    clientOperationId: params['clientOperationId'],
                  ),
        ),
        'requestAccountDeletion': _i1.MethodConnector(
          name: 'requestAccountDeletion',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['privacy'] as _i12.PrivacyEndpoint)
                  .requestAccountDeletion(
                    session,
                    clientOperationId: params['clientOperationId'],
                  ),
        ),
        'cancelAccountDeletion': _i1.MethodConnector(
          name: 'cancelAccountDeletion',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['privacy'] as _i12.PrivacyEndpoint)
                  .cancelAccountDeletion(session),
        ),
        'getStatus': _i1.MethodConnector(
          name: 'getStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['privacy'] as _i12.PrivacyEndpoint)
                  .getStatus(session),
        ),
        'processExportJobs': _i1.MethodConnector(
          name: 'processExportJobs',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['privacy'] as _i12.PrivacyEndpoint)
                  .processExportJobs(session),
        ),
        'processHardDeletion': _i1.MethodConnector(
          name: 'processHardDeletion',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['privacy'] as _i12.PrivacyEndpoint)
                  .processHardDeletion(session),
        ),
      },
    );
    connectors['realtime'] = _i1.EndpointConnector(
      name: 'realtime',
      endpoint: endpoints['realtime']!,
      methodConnectors: {
        'watchFamilyEvents': _i1.MethodStreamConnector(
          name: 'watchFamilyEvents',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['realtime'] as _i13.RealtimeEndpoint)
                  .watchFamilyEvents(
                    session,
                    familyId: params['familyId'],
                  ),
        ),
      },
    );
    connectors['sync'] = _i1.EndpointConnector(
      name: 'sync',
      endpoint: endpoints['sync']!,
      methodConnectors: {
        'changes': _i1.MethodConnector(
          name: 'changes',
          params: {
            'since': _i1.ParameterDescription(
              name: 'since',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'lastSeenChangeId': _i1.ParameterDescription(
              name: 'lastSeenChangeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sync'] as _i14.SyncEndpoint).changes(
                session,
                since: params['since'],
                familyId: params['familyId'],
                limit: params['limit'],
                lastSeenChangeId: params['lastSeenChangeId'],
              ),
        ),
      },
    );
    connectors['tasks'] = _i1.EndpointConnector(
      name: 'tasks',
      endpoint: endpoints['tasks']!,
      methodConnectors: {
        'upsertTask': _i1.MethodConnector(
          name: 'upsertTask',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'taskId': _i1.ParameterDescription(
              name: 'taskId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isPersonal': _i1.ParameterDescription(
              name: 'isPersonal',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'dueAt': _i1.ParameterDescription(
              name: 'dueAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'recurrenceMode': _i1.ParameterDescription(
              name: 'recurrenceMode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'recurrenceRrule': _i1.ParameterDescription(
              name: 'recurrenceRrule',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'assigneeProfileId': _i1.ParameterDescription(
              name: 'assigneeProfileId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i15.TasksEndpoint).upsertTask(
                session,
                clientOperationId: params['clientOperationId'],
                taskId: params['taskId'],
                familyId: params['familyId'],
                title: params['title'],
                description: params['description'],
                isPersonal: params['isPersonal'],
                priority: params['priority'],
                dueAt: params['dueAt'],
                recurrenceMode: params['recurrenceMode'],
                recurrenceRrule: params['recurrenceRrule'],
                assigneeProfileId: params['assigneeProfileId'],
              ),
        ),
        'listTasks': _i1.MethodConnector(
          name: 'listTasks',
          params: {
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i15.TasksEndpoint).listTasks(
                session,
                familyId: params['familyId'],
              ),
        ),
        'completeTask': _i1.MethodConnector(
          name: 'completeTask',
          params: {
            'clientOperationId': _i1.ParameterDescription(
              name: 'clientOperationId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'familyId': _i1.ParameterDescription(
              name: 'familyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'taskId': _i1.ParameterDescription(
              name: 'taskId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tasks'] as _i15.TasksEndpoint).completeTask(
                    session,
                    clientOperationId: params['clientOperationId'],
                    familyId: params['familyId'],
                    taskId: params['taskId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i16.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i17.Endpoints()
      ..initializeEndpoints(server);
  }
}
