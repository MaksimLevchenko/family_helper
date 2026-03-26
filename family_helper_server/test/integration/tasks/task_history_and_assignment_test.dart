import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Task history and assignment validation',
    (sessionBuilder, endpoints) {
      test(
        'listTaskHistory returns newest-first entries with actor names',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final member = authenticatedBuilder(sessionBuilder, user2Id);
          final runId = DateTime.now().microsecondsSinceEpoch;

          final family = await endpoints.family.createFamily(
            owner,
            clientOperationId: 'family-create-task-history-$runId',
            title: 'Task History Family',
          );

          final ownerProfile = await endpoints.profile.update(
            owner,
            clientOperationId: 'profile-owner-task-history-$runId',
            displayName: 'Owner Tester',
            clearAvatarMedia: false,
          );

          final invite = await endpoints.family.createInvite(
            owner,
            familyId: family.id,
            clientOperationId: 'family-invite-task-history-$runId',
            inviteType: 'code',
          );

          await endpoints.family.acceptInvite(
            member,
            clientOperationId: 'family-accept-task-history-$runId',
            tokenOrCode: invite.inviteCode,
          );

          final memberProfile = await endpoints.profile.update(
            member,
            clientOperationId: 'profile-member-task-history-$runId',
            displayName: 'Member Tester',
            clearAvatarMedia: false,
          );

          final task = await endpoints.tasks.upsertTask(
            owner,
            clientOperationId: 'task-create-history-$runId',
            familyId: family.id,
            title: 'Prepare lunchboxes',
            isPersonal: false,
            priority: 'normal',
            assigneeProfileId: memberProfile.id,
          );

          await endpoints.tasks.completeTask(
            member,
            clientOperationId: 'task-complete-history-$runId',
            familyId: family.id,
            taskId: task.id,
          );

          final history = await endpoints.tasks.listTaskHistory(
            owner,
            familyId: family.id,
            taskId: task.id,
            limit: 50,
          );

          expect(history, hasLength(2));
          expect(history.first.eventType, 'completed');
          expect(history.first.actorDisplayName, 'Member Tester');
          expect(history.last.eventType, 'created');
          expect(history.last.actorDisplayName, 'Owner Tester');
          expect(history.last.profileId, ownerProfile.id);
        },
      );

      test(
        'assignment validation rejects invalid assignees and allows active members',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final outsider = authenticatedBuilder(sessionBuilder, user2Id);
          final runId = DateTime.now().microsecondsSinceEpoch;

          final family = await endpoints.family.createFamily(
            owner,
            clientOperationId: 'family-create-assignee-$runId',
            title: 'Assignment Family',
          );

          final outsiderProfile = await endpoints.profile.update(
            outsider,
            clientOperationId: 'profile-outsider-task-$runId',
            displayName: 'Outside Tester',
            clearAvatarMedia: false,
          );

          await expectLater(
            () => endpoints.tasks.upsertTask(
              owner,
              clientOperationId: 'task-invalid-shared-assignee-$runId',
              familyId: family.id,
              title: 'Shared assignment',
              isPersonal: false,
              priority: 'normal',
              assigneeProfileId: outsiderProfile.id,
            ),
            throwsA(isA<ArgumentError>()),
          );

          final invite = await endpoints.family.createInvite(
            owner,
            familyId: family.id,
            clientOperationId: 'family-invite-assignee-$runId',
            inviteType: 'code',
          );

          await endpoints.family.acceptInvite(
            outsider,
            clientOperationId: 'family-accept-assignee-$runId',
            tokenOrCode: invite.inviteCode,
          );

          final assignedTask = await endpoints.tasks.upsertTask(
            owner,
            clientOperationId: 'task-valid-shared-assignee-$runId',
            familyId: family.id,
            title: 'Valid assignment',
            isPersonal: false,
            priority: 'normal',
            assigneeProfileId: outsiderProfile.id,
          );

          expect(assignedTask.assigneeProfileId, outsiderProfile.id);

          await expectLater(
            () => endpoints.tasks.upsertTask(
              owner,
              clientOperationId: 'task-invalid-personal-assignee-$runId',
              familyId: family.id,
              title: 'Personal assignment',
              isPersonal: true,
              priority: 'normal',
              assigneeProfileId: outsiderProfile.id,
            ),
            throwsA(isA<ArgumentError>()),
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
