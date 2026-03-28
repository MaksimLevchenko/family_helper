import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/server_availability_cubit.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../providers/family_provider.dart';

part 'family_screen_forms.dart';
part 'family_screen_sections.dart';

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
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Family')),
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

          final summaryCard = _FamilySummaryCard(
            title: state.family?.title ?? 'Family',
            memberCount: state.members.length,
            canRename: isOwner,
            renameController: _renameFamilyTitleController,
            isLoading: state.isLoading,
            onRename: () async {
              final messenger = ScaffoldMessenger.of(context);
              final renamed = await context
                  .read<FamilyMembersCubit>()
                  .renameFamily(
                    _renameFamilyTitleController.text,
                  );
              if (!mounted || renamed == null) {
                return;
              }
              messenger.showSnackBar(
                const SnackBar(content: Text('Family name updated')),
              );
            },
          );

          final inviteSection = _InviteSection(
            inviteEmailController: _inviteEmailController,
            lastInviteCode: state.lastInviteCode,
            isOffline: isOffline,
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
          );

          final membersSection = _MembersSection(
            currentProfileId: currentProfileId,
            members: state.members,
          );

          final transferSection = _TransferOwnershipSection(
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
                    await context.read<FamilyMembersCubit>().transferOwnership(
                      newOwnerProfileId: _selectedNewOwnerProfileId!,
                    );
                  },
          );

          return ResponsiveContentLayout(
            builder: (context, isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CachedDataStatus(
                    isUsingCachedData: state.isUsingCachedData,
                    lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
                  ),
                  if (state.error != null) ...[
                    AppBanner(text: state.error!, isError: true),
                    const SizedBox(height: 12),
                  ],
                  if (!hasFamily)
                    _EmptyFamilySection(
                      familyTitleController: _createFamilyTitleController,
                      inviteCodeController: _inviteCodeController,
                      isLoading: state.isLoading,
                      isOffline: isOffline,
                      isWide: isWide,
                    )
                  else if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              summaryCard,
                              if (isOwner) ...[
                                const SizedBox(height: 16),
                                inviteSection,
                              ],
                              const SizedBox(height: 16),
                              _FamilyActionCard(
                                isOwner: isOwner,
                                onLeave: () async {
                                  await context
                                      .read<FamilyMembersCubit>()
                                      .leaveFamily();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              membersSection,
                              if (isOwner) ...[
                                const SizedBox(height: 16),
                                transferSection,
                              ],
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    summaryCard,
                    const SizedBox(height: 16),
                    if (isOwner) ...[
                      inviteSection,
                      const SizedBox(height: 16),
                    ],
                    membersSection,
                    if (isOwner) ...[
                      const SizedBox(height: 16),
                      transferSection,
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
          );
        },
      ),
    );
  }
}
