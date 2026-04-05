part of 'family_screen.dart';

class _InviteSection extends StatelessWidget {
  const _InviteSection({
    required this.inviteEmailController,
    required this.lastInviteCode,
    required this.isOffline,
    required this.onCreateEmailInvite,
    required this.onCreateCodeInvite,
    required this.onCopyCode,
  });

  final TextEditingController inviteEmailController;
  final String? lastInviteCode;
  final bool isOffline;
  final Future<void> Function() onCreateEmailInvite;
  final Future<void> Function() onCreateCodeInvite;
  final Future<void> Function()? onCopyCode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.familyInviteMembersTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: inviteEmailController,
              label: context.l10n.familyInviteByEmailLabel,
              hint: 'partner@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.familySendEmailInvite,
              onPressed: isOffline
                  ? null
                  : () async {
                      await onCreateEmailInvite();
                    },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.familyCreateInviteCode,
              variant: AppButtonVariant.secondary,
              onPressed: isOffline
                  ? null
                  : () async {
                      await onCreateCodeInvite();
                    },
            ),
            if (lastInviteCode != null) ...[
              const SizedBox(height: 12),
              AppBanner(
                text: context.l10n.familyShareInviteCode(lastInviteCode!),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: context.l10n.familyCopyInviteCode,
                variant: AppButtonVariant.secondary,
                onPressed: onCopyCode == null
                    ? null
                    : () async {
                        await onCopyCode!();
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MembersSection extends StatelessWidget {
  const _MembersSection({
    required this.currentProfileId,
    required this.members,
  });

  final int? currentProfileId;
  final List<FamilyMemberDto> members;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.familyMembersTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (members.isEmpty)
              Text(context.l10n.familyNoMembersYet)
            else
              ...members.map((member) {
                final isCurrentUser = member.profileId == currentProfileId;
                final roleLabel = _roleLabel(context, member.role);
                final statusLabel = _statusLabel(context, member.status);
                final title = isCurrentUser
                    ? context.l10n.familyMemberYou(member.displayName)
                    : member.displayName;
                return AppTile(
                  title: title,
                  leading: FamilyMemberAvatar(
                    displayName: member.displayName,
                    avatarMediaId: member.avatarMediaId,
                  ),
                  subtitle: '$roleLabel • $statusLabel',
                );
              }),
          ],
        ),
      ),
    );
  }

  static String _roleLabel(BuildContext context, String role) {
    return switch (role) {
      'owner' => context.l10n.familyRoleOwner,
      'member' => context.l10n.familyRoleMember,
      _ => role,
    };
  }

  static String _statusLabel(BuildContext context, String status) {
    return switch (status) {
      'active' => context.l10n.familyStatusActive,
      'left' => context.l10n.familyStatusLeft,
      _ => status,
    };
  }
}

class _TransferOwnershipSection extends StatelessWidget {
  const _TransferOwnershipSection({
    required this.members,
    required this.selectedProfileId,
    required this.isLoading,
    required this.onSelected,
    required this.onTransfer,
  });

  final List<FamilyMemberDto> members;
  final int? selectedProfileId;
  final bool isLoading;
  final ValueChanged<int?> onSelected;
  final Future<void> Function()? onTransfer;

  @override
  Widget build(BuildContext context) {
    final loadSignedUrl = context.read<MediaCubit>().loadSignedUrl;
    final candidates = members
        .where((member) => member.role != 'owner' && member.status == 'active')
        .toList();

    if (candidates.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            context.l10n.familyTransferNeedAnotherMember,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.familyTransferOwnershipTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: ValueKey(selectedProfileId),
              initialValue: selectedProfileId,
              decoration: InputDecoration(
                labelText: context.l10n.familyNewOwnerLabel,
              ),
              items: candidates
                  .map(
                    (member) => DropdownMenuItem<int>(
                      value: member.profileId,
                      child: _MemberOptionLabel(
                        member: member,
                        loadSignedUrl: loadSignedUrl,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onSelected,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.familyTransferOwnershipAction,
              variant: AppButtonVariant.secondary,
              isLoading: isLoading,
              onPressed: onTransfer == null
                  ? null
                  : () async {
                      await onTransfer!();
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyActionCard extends StatelessWidget {
  const _FamilyActionCard({
    required this.isOwner,
    required this.onLeave,
  });

  final bool isOwner;
  final Future<void> Function() onLeave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: context.l10n.familyLeaveAction,
              variant: AppButtonVariant.danger,
              onPressed: isOwner
                  ? null
                  : () async {
                      await onLeave();
                    },
            ),
            if (isOwner) ...[
              const SizedBox(height: 8),
              Text(
                context.l10n.familyTransferBeforeLeave,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MemberOptionLabel extends StatelessWidget {
  const _MemberOptionLabel({
    required this.member,
    required this.loadSignedUrl,
  });

  final FamilyMemberDto member;
  final Future<String> Function(int mediaId) loadSignedUrl;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FamilyMemberAvatar(
            displayName: member.displayName,
            avatarMediaId: member.avatarMediaId,
            size: 28,
            loadSignedUrl: loadSignedUrl,
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 190),
            child: Text(member.displayName, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
