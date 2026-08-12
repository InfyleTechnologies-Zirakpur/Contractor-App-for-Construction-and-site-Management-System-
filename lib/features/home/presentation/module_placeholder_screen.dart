import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/roles/app_role.dart';
import 'package:flutter/material.dart';

/// Temporary stand-in for modules that aren't built yet. Replace
/// `_screenFor`/`HomeShell` handling or its usages as features land.
class ModulePlaceholderScreen extends StatelessWidget {
  const ModulePlaceholderScreen({super.key, required this.module});

  final AppModule module;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(module.label)),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(module.icon, size: 64, color: AppColors.primary.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text('${module.label} module', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Coming soon — this screen will be built next.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}