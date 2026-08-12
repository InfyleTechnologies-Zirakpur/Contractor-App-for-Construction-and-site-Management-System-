import '../models/job_model.dart';

/// Demo data returned while `AppConfig.mockMode` is true. Mutable so the
/// demo "post a job" action shows up in the list within the session.
class JobsMock {
  JobsMock._();

  static final List<JobModel> jobs = [
    JobModel(
      id: 'job-001',
      title: 'Masons needed – Tower B slab work',
      companyName: 'BuildPro Constructions',
      designation: 'Mason',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      totalApplied: 14,
      location: 'Bengaluru, KA',
    ),
    JobModel(
      id: 'job-002',
      title: 'Electricians for site electrification',
      companyName: 'BuildPro Constructions',
      designation: 'Electrician',
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
      totalApplied: 9,
      location: 'Pune, MH',
    ),
    JobModel(
      id: 'job-003',
      title: 'Carpenters for formwork & fit-out',
      companyName: 'BuildPro Constructions',
      designation: 'Carpenter',
      postedAt: DateTime.now().subtract(const Duration(days: 9)),
      totalApplied: 6,
      location: 'Hyderabad, TS',
    ),
    JobModel(
      id: 'job-004',
      title: 'Steel fixers for high-rise columns',
      companyName: 'BuildPro Constructions',
      designation: 'Steel Fixer',
      postedAt: DateTime.now().subtract(const Duration(days: 12)),
      totalApplied: 21,
      location: 'Bengaluru, KA',
    ),
  ];

  static JobModel fromPayload(Map<String, dynamic> payload) {
    final job = JobModel(
      id: 'job-${(jobs.length + 1).toString().padLeft(3, '0')}',
      title: payload['title'] as String,
      companyName:
          payload['company_name'] as String? ?? 'BuildPro Constructions',
      designation: payload['designation'] as String,
      postedAt: DateTime.now(),
      totalApplied: 0,
      location: payload['location'] as String?,
    );
    jobs.insert(0, job);
    return job;
  }
}