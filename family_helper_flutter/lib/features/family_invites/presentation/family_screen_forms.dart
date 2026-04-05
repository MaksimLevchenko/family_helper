part of 'family_screen.dart';

class _EmptyFamilySection extends StatelessWidget {
  const _EmptyFamilySection({
    required this.familyTitleController,
    required this.inviteCodeController,
    required this.isLoading,
    required this.isOffline,
    required this.isWide,
  });

  final TextEditingController familyTitleController;
  final TextEditingController inviteCodeController;
  final bool isLoading;
  final bool isOffline;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final createCard = _CreateFamilyCard(
      familyTitleController: familyTitleController,
      isLoading: isLoading,
      isOffline: isOffline,
    );
    final joinCard = _JoinFamilyCard(
      inviteCodeController: inviteCodeController,
      isOffline: isOffline,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmptyState(
          title: context.l10n.familyEmptyTitle,
          message: context.l10n.familyEmptyMessage,
        ),
        const SizedBox(height: 16),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: createCard),
              const SizedBox(width: 24),
              Expanded(child: joinCard),
            ],
          )
        else ...[
          createCard,
          const SizedBox(height: 16),
          joinCard,
        ],
      ],
    );
  }
}

class _CreateFamilyCard extends StatelessWidget {
  const _CreateFamilyCard({
    required this.familyTitleController,
    required this.isLoading,
    required this.isOffline,
  });

  final TextEditingController familyTitleController;
  final bool isLoading;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.familyCreateTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: familyTitleController,
              label: context.l10n.familyNameLabel,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.familyCreateAction,
              isLoading: isLoading,
              onPressed: isOffline
                  ? null
                  : () async {
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
    );
  }
}

class _JoinFamilyCard extends StatelessWidget {
  const _JoinFamilyCard({
    required this.inviteCodeController,
    required this.isOffline,
  });

  final TextEditingController inviteCodeController;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.familyJoinTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: inviteCodeController,
              label: context.l10n.familyInviteCodeLabel,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.familyJoinAction,
              onPressed: isOffline
                  ? null
                  : () async {
                      final code = inviteCodeController.text.trim();
                      if (code.isEmpty) {
                        return;
                      }
                      await context.read<FamilyMembersCubit>().acceptInvite(
                        code,
                      );
                    },
            ),
          ],
        ),
      ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              context.l10n.familyMembersInFamily(memberCount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (canRename) ...[
              const SizedBox(height: 16),
              AppTextField(
                controller: renameController,
                label: context.l10n.familyNameLabel,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: context.l10n.familySaveNameAction,
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
