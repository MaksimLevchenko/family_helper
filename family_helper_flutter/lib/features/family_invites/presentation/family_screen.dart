import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../providers/family_provider.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final _createFamilyTitleController = TextEditingController();
  final _renameFamilyTitleController = TextEditingController();
  final _inviteEmailController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  int? _selectedNewOwnerProfileId;
  String? _seededFamilyTitle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileBloc = context.read<ProfileBloc>();
      if (profileBloc.state.profile == null) {
        profileBloc.add(const ProfileLoadRequested());
      }

      final familySelectionCubit = context.read<FamilySelectionCubit>();
      final familyMembersCubit = context.read<FamilyMembersCubit>();
      if (familySelectionCubit.state != null &&
          familyMembersCubit.state.family == null &&
          !familyMembersCubit.state.isLoading) {
        familyMembersCubit.loadMembers();
      }
    });
  }

  @override
  void dispose() {
    _createFamilyTitleController.dispose();
    _renameFamilyTitleController.dispose();
    _inviteEmailController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProfileId = context.watch<ProfileBloc>().state.profile?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Family')),
      body: BlocBuilder<FamilyMembersCubit, FamilyMembersState>(
        builder: (context, state) {
          if (state.isLoading &&
              state.familyId != null &&
              state.family == null) {
            return const LoadingState();
          }

          if (state.error != null &&
              state.familyId != null &&
              state.family == null) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<FamilyMembersCubit>().loadMembers(),
            );
          }

          final hasFamily = state.familyId != null;
          final isOwner =
              hasFamily &&
              currentProfileId != null &&
              currentProfileId == state.family?.ownerProfileId;
          if (state.family != null &&
              _seededFamilyTitle != state.family!.title) {
            _seededFamilyTitle = state.family!.title;
            _renameFamilyTitleController.value = TextEditingValue(
              text: state.family!.title,
              selection: TextSelection.collapsed(
                offset: state.family!.title.length,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              if (!hasFamily) ...[
                _EmptyFamilySection(
                  familyTitleController: _createFamilyTitleController,
                  inviteCodeController: _inviteCodeController,
                  isLoading: state.isLoading,
                ),
              ] else ...[
                _FamilySummaryCard(
                  title: state.family?.title ?? 'Family',
                  memberCount: state.members.length,
                  canRename: isOwner,
                  renameController: _renameFamilyTitleController,
                  isLoading: state.isLoading,
                  onRename: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final renamed = await context
                        .read<FamilyMembersCubit>()
                        .renameFamily(_renameFamilyTitleController.text);
                    if (!mounted || renamed == null) {
                      return;
                    }
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Family name updated')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _InviteSection(
                  inviteEmailController: _inviteEmailController,
                  lastInviteCode: state.lastInviteCode,
                  onCreateEmailInvite: () async {
                    await context.read<FamilyMembersCubit>().createInvite(
                      inviteType: 'email',
                      email: _inviteEmailController.text.trim(),
                    );
                  },
                  onCreateCodeInvite: () async {
                    await context.read<FamilyMembersCubit>().createInvite(
                      inviteType: 'code',
                    );
                  },
                  onCopyCode: state.lastInviteCode == null
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await Clipboard.setData(
                            ClipboardData(text: state.lastInviteCode!),
                          );
                          if (!mounted) {
                            return;
                          }
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Invite code copied')),
                          );
                        },
                ),
                const SizedBox(height: 16),
                _MembersSection(
                  currentProfileId: currentProfileId,
                  members: state.members,
                ),
                if (isOwner) ...[
                  const SizedBox(height: 16),
                  _TransferOwnershipSection(
                    members: state.members,
                    selectedProfileId: _selectedNewOwnerProfileId,
                    isLoading: state.isLoading,
                    onSelected: (value) {
                      setState(() {
                        _selectedNewOwnerProfileId = value;
                      });
                    },
                    onTransfer: _selectedNewOwnerProfileId == null
                        ? null
                        : () async {
                            await context
                                .read<FamilyMembersCubit>()
                                .transferOwnership(
                                  newOwnerProfileId:
                                      _selectedNewOwnerProfileId!,
                                );
                          },
                  ),
                ],
                const SizedBox(height: 16),
                AppButton(
                  label: 'Leave family',
                  variant: AppButtonVariant.danger,
                  onPressed: isOwner
                      ? null
                      : () async {
                          await context
                              .read<FamilyMembersCubit>()
                              .leaveFamily();
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
            ],
          );
        },
      ),
    );
  }
}

class _EmptyFamilySection extends StatelessWidget {
  const _EmptyFamilySection({
    required this.familyTitleController,
    required this.inviteCodeController,
    required this.isLoading,
  });

  final TextEditingController familyTitleController;
  final TextEditingController inviteCodeController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmptyState(
          title: 'No family connected',
          message: 'Create a family or join one with an invite code.',
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a family',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: familyTitleController,
                  label: 'Family name',
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Create family',
                  isLoading: isLoading,
                  onPressed: () async {
                    final title = familyTitleController.text.trim();
                    if (title.isEmpty) {
                      return;
                    }
                    await context.read<FamilyMembersCubit>().createFamily(
                      title,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join with an invite',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: inviteCodeController,
                  label: 'Invite code',
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Join family',
                  onPressed: () async {
                    final code = inviteCodeController.text.trim();
                    if (code.isEmpty) {
                      return;
                    }
                    await context.read<FamilyMembersCubit>().acceptInvite(code);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FamilySummaryCard extends StatelessWidget {
  const _FamilySummaryCard({
    required this.title,
    required this.memberCount,
    required this.canRename,
    required this.renameController,
    required this.isLoading,
    required this.onRename,
  });

  final String title;
  final int memberCount;
  final bool canRename;
  final TextEditingController renameController;
  final bool isLoading;
  final Future<void> Function() onRename;

  @override
  Widget build(BuildContext context) {
    final memberLabel = memberCount == 1 ? 'member' : 'members';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              '$memberCount $memberLabel in your family',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (canRename) ...[
              const SizedBox(height: 16),
              AppTextField(
                controller: renameController,
                label: 'Family name',
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Save family name',
                variant: AppButtonVariant.secondary,
                isLoading: isLoading,
                onPressed: () async {
                  await onRename();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InviteSection extends StatelessWidget {
  const _InviteSection({
    required this.inviteEmailController,
    required this.lastInviteCode,
    required this.onCreateEmailInvite,
    required this.onCreateCodeInvite,
    required this.onCopyCode,
  });

  final TextEditingController inviteEmailController;
  final String? lastInviteCode;
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
              onPressed: () async {
                await onCreateEmailInvite();
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Create invite code',
              variant: AppButtonVariant.secondary,
              onPressed: () async {
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
