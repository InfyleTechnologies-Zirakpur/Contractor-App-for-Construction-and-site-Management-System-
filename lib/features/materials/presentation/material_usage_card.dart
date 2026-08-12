import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/materials/data/models/material_usage_model.dart';
import 'package:flutter/material.dart';

/// Compact "material usage" card: name, project, requested/used qty and a
/// usage progress bar. Shared by the dashboard section and MaterialsScreen.
class MaterialUsageCard extends StatelessWidget {
  const MaterialUsageCard({super.key, required this.usage, this.onTap});

  final MaterialUsageModel usage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = usage.usagePercent;
    final isExhausted = usage.usedQty >= usage.requestedQty && usage.requestedQty > 0;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(context.w(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.w(14)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(context.w(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.w(14)),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.w(8)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(context.w(8)),
                    ),
                    child: Icon(Icons.inventory_2_outlined,
                        color: AppColors.primary, size: context.sp(18)),
                  ),
                  SizedBox(width: context.w(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(usage.materialName, style: theme.textTheme.titleSmall),
                        if (usage.projectName != null)
                          Text(usage.projectName!, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (isExhausted)
                    Text(
                      'Exhausted',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.statusRejected,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              SizedBox(height: context.h(10)),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: context.h(6),
                  backgroundColor: AppColors.divider,
                  color: percent > 80 ? AppColors.statusLate : AppColors.primary,
                ),
              ),
              SizedBox(height: context.h(6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Used ${usage.usedQty._formatted()} / ${usage.requestedQty._formatted()} ${usage.unit}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '${percent.round()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on num {
  String _formatted() {
    if (this == toInt()) return toInt().toString();
    return toStringAsFixed(1);
  }
}