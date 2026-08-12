import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/recruitment/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// WhatsApp-chat-style row for a posted job: avatar, title, company •
/// designation line, a "date tag" (top-right) and an applied-count badge
/// (bottom-right). Shared by the dashboard section and RecruitmentScreen.
class JobListTile extends StatelessWidget {
  const JobListTile({super.key, required this.job, this.onTap});

  final JobModel job;
  final VoidCallback? onTap;

  String _dateTag() {
    final current = DateTime.now();
    final diff = current.difference(job.postedAt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('dd MMM').format(job.postedAt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(context.w(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.w(14)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(14),
            vertical: context.h(10),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.w(14)),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: context.sp(20),
                backgroundColor: AppColors.primary.withValues(alpha: 0.14),
                child: Text(
                  job.title.isEmpty ? '?' : job.title[0].toUpperCase(),
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: AppColors.primary),
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: context.w(6)),
                        Text(
                          _dateTag(),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      '${job.companyName} • ${job.designation}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (job.location != null) ...[
                      SizedBox(height: context.h(2)),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: context.sp(13), color: AppColors.textSecondary),
                          SizedBox(width: context.w(3)),
                          Expanded(
                            child: Text(
                              job.location!,
                              style: theme.textTheme.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: context.w(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(8),
                      vertical: context.h(2),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${job.totalApplied} applied',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (job.status == JobStatus.closed) ...[
                    SizedBox(height: context.h(6)),
                    Text(
                      'Closed',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}