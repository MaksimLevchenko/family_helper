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
              'Invite family members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: inviteEmailController,
              label: 'Invite by email',
              hint: 'partner@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Send email invite',
              onPressed: isOffline
                  ? null
                  : () async {
                      await onCreateEmailInvite();
                    },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Create invite code',
              variant: AppButtonVariant.secondary,
              onPressed: isOffline
                  ? null
                  : () async {
                      await onCreateCodeInvite();
                    },
            ),
            if (lastInviteCode != null) ...[
              const SizedBox(height: 12),
              AppBanner(text: 'Share this invite code: $lastInviteCode'),
              const SizedBox(height: 12),
              AppButton(
                label: 'Copy invite code',
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
              'Family members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (members.isEmpty)
              const Text('No members yet')
            else
              ...members.map((member) {
                final isCurrentUser = member.profileId == currentProfileId;
                final roleLabel = _roleLabel(member.role);
                final statusLabel = _statusLabel(member.status);
                final title = isCurrentUser
                    ? '${member.displayName} (You)'
                    : member.displayName;
                return AppTile(
                  title: title,
                  subtitle: '$roleLabel • $statusLabel',
                );
              }),
          ],
        ),
      ),
    );
  }

  static String _roleLabel(String role) {
    return switch (role) {
      'owner' => 'Owner',
      'member' => 'Member',
      _ => role,
    };
  }

  static String _statusLabel(String status) {
    return switch (status) {
      'active' => 'Active',
      'left' => 'Left',
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
    final candidates = members
        .where((member) => member.role != 'owner' && member.status == 'active')
        .toList();

    if (candidates.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Add another active member before transferring ownership.',
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
              'Transfer ownership',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: ValueKey(selectedProfileId),
              initialValue: selectedProfileId,
              decoration: const InputDecoration(labelText: 'New owner'),
              items: candidates
                  .map(
                    (member) => DropdownMenuItem<int>(
                      value: member.profileId,
                      child: Text(member.displayName),
                    ),
                  )
                  .toList(),
              onChanged: onSelected,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Transfer ownership',
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
              label: 'Leave family',
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
                'Transfer ownership before leaving the family.',
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
