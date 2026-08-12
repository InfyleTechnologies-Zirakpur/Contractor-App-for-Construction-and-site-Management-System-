class ApiEndpoints {
  ApiEndpoints._();

  // ---- Auth ----
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/logout';
  static const String verifyResetOtp = '/auth/logout';
  static const String resetPassword = '/auth/logout';
  static const String changePassword = '/auth/logout';

  // ---- Home ----
  static const String homeProfile = '/home/profile';
  static String toggleActionVisibility(String actionId) =>
      '/home/actions/$actionId/visibility';

  // ---- Company (contractor + sub-contractor) ----
  static const String registerCompany = '/company/register';
  static const String companyProfile = '/company/profile';
  static const String updateCompanyProfile = '/company/profile';
  static const String companyVerificationStatus = '/company/verification/status';
  static const String submitCompanyVerification = '/company/verification';

  // ---- Projects ----
  static const String projects = '/projects';
  static const String createProject = '/projects';
  static String projectDetails(String projectId) => '/projects/$projectId';
  static String updateProject(String projectId) => '/projects/$projectId';
  static String deleteProject(String projectId) => '/projects/$projectId';
  static String projectProgress(String projectId) => '/projects/$projectId/progress';
  static String workforceRequirements(String projectId) =>
      '/projects/$projectId/workforce-requirements';
  static String postWorkforceRequirement(String projectId) =>
      '/projects/$projectId/workforce-requirements';
  static String assignWorkerToProject(String projectId) =>
      '/projects/$projectId/assign-worker';

  // ---- Materials ----
  static const String materialRequests = '/materials/requests';
  static const String raiseMaterialRequest = '/materials/requests';
  static const String materialUsage = '/materials/usage';
  static const String logMaterialUsage = '/materials/usage';

  // ---- Recruitment / posted jobs ----
  static const String postedJobs = '/jobs/posted';
  static const String postJob = '/jobs';
  static const String searchWorkers = '/workers/search';
  static String workerProfile(String workerId) => '/workers/$workerId';
  static String projectApplications(String projectId) =>
      '/projects/$projectId/applications';
  static String reviewApplication(String applicationId) =>
      '/applications/$applicationId/review';
  static String hireWorker(String workerId) => '/workers/$workerId/hire';
}