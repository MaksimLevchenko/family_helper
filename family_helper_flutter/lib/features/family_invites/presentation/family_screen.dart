import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../providers/family_provider.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final _familyTitleController = TextEditingController();
  final _inviteEmailController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  @override
  void dispose() {
    _familyTitleController.dispose();
    _inviteEmailController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final familyId = context.select(
      (FamilySelectionCubit cubit) => cubit.state,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Family & Invites')),
      body: BlocBuilder<FamilyMembersCubit, FamilyMembersState>(
        builder: (context, state) {
          if (state.isLoading && state.members.isEmpty) {
            return const LoadingState();
          }

          if (state.error != null && state.members.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<FamilyMembersCubit>().loadMembers(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppTextField(
                controller: _familyTitleController,
                label: 'Family title',
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create family',
                isLoading: state.isLoading,
                onPressed: () async {
                  final title = _familyTitleController.text.trim();
                  if (title.isEmpty) {
                    return;
                  }
                  await context.read<FamilyMembersCubit>().createFamily(title);
                },
              ),
              const SizedBox(height: 24),
              Text(
                familyId == null
                    ? 'No selected family'
                    : 'Current family id: $familyId',
                style: TextStyle(color: colors.textSecondary),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _inviteEmailController,
                label: 'Invite by email',
                hint: 'partner@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create email invite',
                onPressed: familyId == null
                    ? null
                    : () async {
                        await context.read<FamilyMembersCubit>().createInvite(
                          inviteType: 'email',
                          email: _inviteEmailController.text.trim(),
                        );
                      },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create code invite',
                onPressed: familyId == null
                    ? null
                    : () async {
                        await context.read<FamilyMembersCubit>().createInvite(
                          inviteType: 'code',
                        );
                      },
              ),
              if (state.lastInviteCode != null) ...[
                const SizedBox(height: 12),
                AppBanner(text: 'Last invite code: ${state.lastInviteCode}'),
              ],
              const SizedBox(height: 24),
              AppTextField(
                controller: _inviteCodeController,
                label: 'Accept invite token or code',
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Accept invite',
                onPressed: () async {
                  final code = _inviteCodeController.text.trim();
                  if (code.isEmpty) {
                    return;
                  }
                  await context.read<FamilyMembersCubit>().acceptInvite(code);
                },
              ),
              const SizedBox(height: 24),
              if (state.members.isEmpty)
                const EmptyState(
                  title: 'No members yet',
                  message: 'Create a family or accept an invite.',
                )
              else
                ...state.members.map(
                  (member) => AppTile(
                    title: member.displayName,
                    subtitle: 'Role: ${member.role}, Status: ${member.status}',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
