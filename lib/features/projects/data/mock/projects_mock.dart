import 'package:contractor_app/features/projects/data/models/project_model.dart';

/// Demo data returned while `AppConfig.mockMode` is true. Kept mutable so the
/// demo create-project/post-requirement actions feel real within the session.
class ProjectsMock {
  ProjectsMock._();

  static final List<ProjectModel> projects = [
    ProjectModel(
      id: 'prj-001',
      name: 'Skyline Residency – Tower B',
      status: ProjectStatus.inProgress,
      progressPercent: 62,
      description:
          '28-storey residential tower with 4BHK luxury flats, podium parking and clubhouse.',
      location: 'Bengaluru, KA',
      startDate: DateTime(2025, 8, 1),
      endDate: DateTime(2026, 5, 30),
      workerCount: 48,
    ),
    ProjectModel(
      id: 'prj-002',
      name: 'Green Valley Township Phase 1',
      status: ProjectStatus.inProgress,
      progressPercent: 28,
      description:
          'Township development with 1200 units, schools, commercial plots and internal roads.',
      location: 'Pune, MH',
      startDate: DateTime(2025, 11, 15),
      endDate: DateTime(2027, 3, 31),
      workerCount: 35,
    ),
    ProjectModel(
      id: 'prj-003',
      name: 'Metro Mall Fit-out',
      status: ProjectStatus.planned,
      progressPercent: 0,
      description:
          'Full interior fit-out for a 5-floor mall — electrical, flooring, ceilings and facades.',
      location: 'Hyderabad, TS',
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2027, 2, 28),
      workerCount: 0,
    ),
    ProjectModel(
      id: 'prj-004',
      name: 'Riverside Apartments',
      status: ProjectStatus.completed,
      progressPercent: 100,
      description:
          'Completed river-facing apartment complex with 3 towers and basement parking.',
      location: 'Chennai, TN',
      startDate: DateTime(2024, 4, 10),
      endDate: DateTime(2025, 12, 20),
      workerCount: 0,
    ),
  ];

  static ProjectModel fromPayload(Map<String, dynamic> payload) {
    final now = DateTime.now();
    return ProjectModel(
      id: 'prj-${(projects.length + 1).toString().padLeft(3, '0')}',
      name: payload['name'] as String? ?? 'Untitled Project',
      status: ProjectStatus.planned,
      progressPercent: 0,
      location: payload['location'] as String?,
      startDate: DateTime.tryParse(payload['start_date'] as String? ?? '') ?? now,
      endDate: DateTime.tryParse(payload['end_date'] as String? ?? ''),
      workerCount: 0,
    );
  }

  static List<WorkforceRequirementModel> requirementsFor(String projectId) {
    if (projectId != 'prj-001') {
      return [
        WorkforceRequirementModel(
          id: '$projectId-w1',
          role: 'Mason',
          count: 6,
          neededBy: DateTime.now().add(const Duration(days: 7)),
        ),
      ];
    }
    return [
      WorkforceRequirementModel(
        id: 'prj-001-w1',
        role: 'Mason',
        count: 6,
        neededBy: DateTime(2026, 8, 20),
      ),
      WorkforceRequirementModel(
        id: 'prj-001-w2',
        role: 'Electrician',
        count: 3,
        neededBy: DateTime(2026, 9, 5),
      ),
      WorkforceRequirementModel(
        id: 'prj-001-w3',
        role: 'Carpenter',
        count: 4,
        neededBy: DateTime(2026, 9, 15),
      ),
    ];
  }
}