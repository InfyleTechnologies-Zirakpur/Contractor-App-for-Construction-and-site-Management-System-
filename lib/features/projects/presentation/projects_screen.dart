import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/projects/data/models/project_model.dart';
import 'package:contractor_app/features/projects/data/services/project_service.dart';
import 'package:flutter/material.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<ProjectModel> _projects = [];
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
      final projects = await ProjectService.instance.getProjects();
      if (!mounted) return;
      setState(() => _projects = projects);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not load projects.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createProject() async {
    final created = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const _CreateProjectDialog(),
    );
    if (created == null) return;
    final project = await ProjectService.instance.createProject(created);
    if (!mounted) return;
    setState(() => _projects.insert(0, project));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      floatingActionButton: FloatingActionButton(
        onPressed: _createProject,
        child: const Icon(Icons.add),
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
              : _projects.isEmpty
                  ? const Center(child: Text('No projects yet — create one.'))
                  : ListView.builder(
                      padding: EdgeInsets.all(context.w(16)),
                      itemCount: _projects.length,
                      itemBuilder: (context, index) {
                        final project = _projects[index];
                        return _ProjectCard(
                          project: project,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProjectDetailScreen(projectId: project.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final ProjectModel project;
  final VoidCallback onTap;

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

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(context.w(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.w(16)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(context.w(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.w(16)),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(project.name, style: theme.textTheme.titleSmall),
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
              SizedBox(height: context.h(8)),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: context.sp(16), color: AppColors.textSecondary),
                  SizedBox(width: context.w(4)),
                  Expanded(
                    child: Text(
                      project.location ?? 'Location TBD',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              if (project.workerCount > 0) ...[
                SizedBox(height: context.h(4)),
                Text('${project.workerCount} workers', style: theme.textTheme.bodySmall),
              ],
              SizedBox(height: context.h(10)),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.progressPercent / 100,
                  minHeight: context.h(6),
                  backgroundColor: AppColors.divider,
                  color: statusColor,
                ),
              ),
              SizedBox(height: context.h(6)),
              Text(
                '${project.progressPercent.round()}% complete',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateProjectDialog extends StatefulWidget {
  const _CreateProjectDialog();

  @override
  State<_CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<_CreateProjectDialog> {
  final _name = TextEditingController();
  final _location = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Project name is required.');
      return;
    }
    Navigator.of(context).pop({
      'name': _name.text.trim(),
      'location': _location.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Project name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _location,
            decoration: const InputDecoration(labelText: 'Location'),
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
        ElevatedButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}