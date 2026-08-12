import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/projects/data/models/project_model.dart';
import 'package:contractor_app/features/projects/data/services/project_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  ProjectModel? _project;
  List<WorkforceRequirementModel> _requirements = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        ProjectService.instance.getProjectDetails(widget.projectId),
        ProjectService.instance.getWorkforceRequirements(widget.projectId),
      ]);
      if (!mounted) return;
      setState(() {
        _project = results[0] as ProjectModel;
        _requirements = results[1] as List<WorkforceRequirementModel>;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not load project details.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _postRequirement() async {
    final req = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const _RequirementDialog(),
    );
    if (req == null) return;
    final created =
        await ProjectService.instance.postWorkforceRequirement(widget.projectId, req);
    if (!mounted) return;
    setState(() => _requirements.insert(0, created));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Project details')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _postRequirement,
        icon: const Icon(Icons.add),
        label: const Text('Post requirement'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(_error!),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(context.w(20)),
                  children: [
                    if (_project != null) _ProjectHeader(project: _project!),
                    SizedBox(height: context.h(20)),
                    Text('Workforce requirements', style: theme.textTheme.titleMedium),
                    SizedBox(height: context.h(10)),
                    if (_requirements.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: context.h(20)),
                        child: Center(
                          child: Text(
                            'No workforce requirements yet.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                    else
                      for (final req in _requirements)
                        Padding(
                          padding: EdgeInsets.only(bottom: context.h(10)),
                          child: _RequirementCard(requirement: req),
                        ),
                  ],
                ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({required this.requirement});

  final WorkforceRequirementModel requirement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.w(10)),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.w(10)),
            ),
            child: Text(
              '${requirement.count}',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(requirement.role, style: theme.textTheme.titleSmall),
                Text(
                  'Needed by ${DateFormat('dd MMM yyyy').format(requirement.neededBy)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(requirement.count > 1 ? 'workers' : 'worker',
              style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (project.status) {
      ProjectStatus.planned => AppColors.statusLate,
      ProjectStatus.inProgress => AppColors.primary,
      ProjectStatus.onHold => AppColors.statusHalfDay,
      ProjectStatus.completed => AppColors.statusPresent,
    };
    final statusLabel = switch (project.status) {
      ProjectStatus.planned => 'Planned',
      ProjectStatus.inProgress => 'In Progress',
      ProjectStatus.onHold => 'On Hold',
      ProjectStatus.completed => 'Completed',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.w(18)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.w(16)),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(project.name, style: theme.textTheme.titleMedium),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(8),
                      vertical: context.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(12)),
              if (project.description != null) ...[
                Text(project.description!, style: theme.textTheme.bodyMedium),
                SizedBox(height: context.h(10)),
              ],
              if (project.location != null) ...[
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: context.sp(16), color: AppColors.textSecondary),
                    SizedBox(width: context.w(6)),
                    Text(project.location!, style: theme.textTheme.bodyMedium),
                  ],
                ),
                SizedBox(height: context.h(6)),
              ],
              if (project.startDate != null)
                Text(
                  'Started ${DateFormat('dd MMM yyyy').format(project.startDate!)}',
                  style: theme.textTheme.bodySmall,
                ),
              SizedBox(height: context.h(14)),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.progressPercent / 100,
                  minHeight: context.h(8),
                  backgroundColor: AppColors.divider,
                  color: statusColor,
                ),
              ),
              SizedBox(height: context.h(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${project.progressPercent.round()}% complete',
                      style: theme.textTheme.bodySmall),
                  if (project.workerCount > 0)
                    Text('${project.workerCount} workers assigned',
                        style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequirementDialog extends StatefulWidget {
  const _RequirementDialog();

  @override
  State<_RequirementDialog> createState() => _RequirementDialogState();
}

class _RequirementDialogState extends State<_RequirementDialog> {
  final _role = TextEditingController();
  final _count = TextEditingController();
  DateTime _neededBy = DateTime.now().add(const Duration(days: 7));
  String? _error;

  @override
  void dispose() {
    _role.dispose();
    _count.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _neededBy,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _neededBy = picked);
  }

  void _submit() {
    final role = _role.text.trim();
    final count = int.tryParse(_count.text.trim());
    if (role.isEmpty || count == null || count <= 0) {
      setState(() => _error = 'Role and a positive count are required.');
      return;
    }
    Navigator.of(context).pop({
      'role': role,
      'count': count,
      'needed_by': _neededBy.toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Post workforce requirement'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _role,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Role',
              hintText: 'e.g. Mason, Electrician',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _count,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Workers needed'),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Needed by'),
              child: Text(
                DateFormat('dd MMM yyyy').format(_neededBy),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: AppColors.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Post')),
      ],
    );
  }
}