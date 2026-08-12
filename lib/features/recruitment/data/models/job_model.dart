enum JobStatus { open, closed }

JobStatus _statusFromString(String? value) {
  switch (value) {
    case 'closed':
      return JobStatus.closed;
    default:
      return JobStatus.open;
  }
}

/// A job post published by a contractor for workers to apply to.
class JobModel {
  const JobModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.designation,
    required this.postedAt,
    required this.totalApplied,
    this.location,
    this.status = JobStatus.open,
  });

  final String id;
  final String title;
  final String companyName;
  final String designation;
  final DateTime postedAt;
  final int totalApplied;
  final String? location;
  final JobStatus status;

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        id: json['id'] as String,
        title: json['title'] as String,
        companyName: json['company_name'] as String,
        designation: json['designation'] as String,
        postedAt: DateTime.parse(json['posted_at'] as String),
        totalApplied: json['total_applied'] as int? ?? 0,
        location: json['location'] as String?,
        status: _statusFromString(json['status'] as String?),
      );
}