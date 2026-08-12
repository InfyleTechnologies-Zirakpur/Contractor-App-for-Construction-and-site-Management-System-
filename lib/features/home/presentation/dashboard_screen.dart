import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/roles/app_role.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/auth/data/services/auth_session_store.dart';
import 'package:contractor_app/features/auth/view/login_screen.dart';
import 'package:contractor_app/features/materials/data/models/material_usage_model.dart';
import 'package:contractor_app/features/materials/data/services/material_service.dart';
import 'package:contractor_app/features/materials/presentation/material_usage_card.dart';
import 'package:contractor_app/features/projects/data/models/project_model.dart';
import 'package:contractor_app/features/projects/data/services/project_service.dart';
import 'package:contractor_app/features/projects/presentation/project_detail_screen.dart';
import 'package:contractor_app/features/recruitment/data/models/job_model.dart';
import 'package:contractor_app/features/recruitment/data/services/recruitment_service.dart';
import 'package:contractor_app/features/recruitment/presentation/job_list_tile.dart';
import 'package:flutter/material.dart';
import 'screen_registry.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Future<List<ProjectModel>> _projectsFuture;
  late final Future<List<MaterialUsageModel>> _materialsFuture;
  late final Future<List<JobModel>>? _jobsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService.instance.getProjects();
    _materialsFuture = MaterialService.instance.getMaterialUsage();
    final showJobs = AuthSessionStore.instance.role.modules
        .contains(AppModule.recruitment);
    _jobsFuture = showJobs ? RecruitmentService.instance.getPostedJobs() : null;
  }

  void _push(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final role = AuthSessionStore.instance.role;
    final name = AuthSessionStore.instance.name;
    final otherModules = role.modules
        .where((m) => !_coveredModules.contains(m) && m != AppModule.dashboard)
        .toList();

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(context.w(20)),
        children: [
          _Header(name: name, role: role),
          SizedBox(height: context.h(20)),
          _SectionHeader(
            title: 'Projects',
            onSeeAll: () => _push(screenFor(AppModule.projects)),
          ),
          SizedBox(height: context.h(10)),
          FutureBuilder<List<ProjectModel>>(
            future: _projectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const _SectionLoading();
              }
              if (snapshot.hasError) {
                return const Text('Could not load projects.');
              }
              final projects = snapshot.data ?? [];
              if (projects.isEmpty) {
                return Text('No projects yet — create one.',
                    style: theme.textTheme.bodySmall);
              }
              return _Carousel(
                slides: [
                  for (final project in projects)
                    _ProjectMiniCard(
                      project: project,
                      onTap: () => _push(
                        ProjectDetailScreen(projectId: project.id),
                      ),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: context.h(20)),
          _SectionHeader(
            title: 'Materials & usage',
            onSeeAll: () => _push(screenFor(AppModule.materials)),
          ),
          SizedBox(height: context.h(10)),
          FutureBuilder<List<MaterialUsageModel>>(
            future: _materialsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const _SectionLoading();
              }
              if (snapshot.hasError) {
                return const Text('Could not load material usage.');
              }
              final usage = snapshot.data ?? [];
              if (usage.isEmpty) {
                return Text('No material usage recorded.',
                    style: theme.textTheme.bodySmall);
              }
              return _Carousel(
                slides: [
                  for (final item in usage)
                    MaterialUsageCard(
                      usage: item,
                      onTap: () => _push(screenFor(AppModule.materials)),
                    ),
                ],
              );
            },
          ),
          if (_jobsFuture != null) ...[
            SizedBox(height: context.h(20)),
            _SectionHeader(
              title: 'Posted jobs',
              onSeeAll: () => _push(screenFor(AppModule.recruitment)),
            ),
            SizedBox(height: context.h(10)),
            FutureBuilder<List<JobModel>>(
              future: _jobsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _SectionLoading();
                }
                if (snapshot.hasError) {
                  return const Text('Could not load jobs.');
                }
                final jobs = snapshot.data ?? [];
                if (jobs.isEmpty) {
                  return Text('No jobs posted yet.',
                      style: theme.textTheme.bodySmall);
                }
                return Column(
                  children: [
                    for (final job in jobs.take(4))
                      Padding(
                        padding: EdgeInsets.only(bottom: context.h(10)),
                        child: JobListTile(
                          job: job,
                          onTap: () => _push(screenFor(AppModule.recruitment)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          if (otherModules.isNotEmpty) ...[
            SizedBox(height: context.h(20)),
            Text('More', style: theme.textTheme.titleMedium),
            SizedBox(height: context.h(10)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: [
                for (final module in otherModules)
                  ActionChip(
                    avatar: Icon(module.icon,
                        size: context.sp(16), color: AppColors.primary),
                    label: Text(module.label),
                    onPressed: () => _push(screenFor(module)),
                  ),
              ],
            ),
          ],
          SizedBox(height: context.h(20)),
        ],
      ),
    );
  }

  static const _coveredModules = {
    AppModule.projects,
    AppModule.materials,
    AppModule.recruitment,
    AppModule.company,
  };
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.role});

  final String? name;
  final AppRole role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good day${name != null ? ', $name' : ''}',
                style: theme.textTheme.titleLarge,
              ),
              Container(
                margin: EdgeInsets.only(top: context.h(4)),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(3),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Log out',
          onPressed: () {
            AuthSessionStore.instance.clear();
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.logout, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See all'),
        ),
      ],
    );
  }
}

class _ProjectMiniCard extends StatelessWidget {
  const _ProjectMiniCard({required this.project, required this.onTap});

  final ProjectModel project;
  final VoidCallback onTap;

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
          padding: EdgeInsets.all(context.w(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.w(14)),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.name, style: theme.textTheme.titleSmall),
              if (project.description != null) ...[
                SizedBox(height: context.h(4)),
                Text(
                  project.description!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: context.h(10)),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.progressPercent / 100,
                  minHeight: context.h(6),
                  backgroundColor: AppColors.divider,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: context.h(6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${project.progressPercent.round()}% • ${project.location ?? 'Location TBD'}',
                    style: theme.textTheme.labelSmall,
                  ),
                  if (project.workerCount > 0)
                    Text('${project.workerCount} workers',
                        style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

/// Horizontal paging carousel: one card snaps per slide (with a peek of the
/// next), dot indicator below. Used for the Projects and Materials sections.
class _Carousel extends StatefulWidget {
  const _Carousel({required this.slides});

  final List<Widget> slides;

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.h(165),
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.slides.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(6)),
              child: widget.slides[index],
            ),
          ),
        ),
        SizedBox(height: context.h(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _index ? context.w(16) : context.w(6),
                height: context.h(6),
                margin: EdgeInsets.symmetric(horizontal: context.w(3)),
                decoration: BoxDecoration(
                  color: i == _index ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}