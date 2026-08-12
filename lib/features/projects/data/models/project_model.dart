enum ProjectStatus { planned, inProgress, onHold, completed }

ProjectStatus _statusFromString(String? value) {
  switch (value) {
    case 'in_progress':
      return ProjectStatus.inProgress;
    case 'on_hold':
      return ProjectStatus.onHold;
    case 'completed':
      return ProjectStatus.completed;
    default:
      return ProjectStatus.planned;
  }
}

class ProjectModel {
  ProjectModel({
    required this.id,
    required this.name,
    required this.status,
    required this.progressPercent,
    this.description,
    this.location,
    this.startDate,
    this.endDate,
    this.workerCount = 0,
  });

  final String id;
  final String name;
  final ProjectStatus status;
  final double progressPercent;
  final String? description;
  final String? location;
  final DateTime? startDate;
  final DateTime? endDate;
  final int workerCount;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'] as String,
        name: json['name'] as String,
        status: _statusFromString(json['status'] as String?),
        progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0,
        description: json['description'] as String?,
        location: json['location'] as String?,
        startDate:
            json['start_date'] != null ? DateTime.tryParse(json['start_date']) : null,
        endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
        workerCount: json['worker_count'] as int? ?? 0,
      );
}

/// A workforce requirement posted against a project
/// (e.g. "need 5 masons, 3 electricians by 20th Aug").
class WorkforceRequirementModel {
  WorkforceRequirementModel({
    required this.id,
    required this.role,
    required this.count,
    required this.neededBy,
  });

  final String id;
  final String role;
  final int count;
  final DateTime neededBy;

  factory WorkforceRequirementModel.fromJson(Map<String, dynamic> json) =>
      WorkforceRequirementModel(
        id: json['id'] as String,
        role: json['role'] as String,
        count: json['count'] as int,
        neededBy: DateTime.parse(json['needed_by'] as String),
      );

  Map<String, dynamic> toJson() => {
        'role': role,
        'count': count,
        'needed_by': neededBy.toIso8601String(),
      };
}
