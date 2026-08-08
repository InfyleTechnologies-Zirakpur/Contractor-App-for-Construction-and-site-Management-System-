// import '../../../../core/api/api_client.dart';
// import '../../../../core/api/api_endpoints.dart';
// import '../../../../core/api/api_request_builder.dart';
// import '../models/project_model.dart';

// class ProjectService {
//   ProjectService._();
//   static final instance = ProjectService._();

//   Future<List<ProjectModel>> getProjects({bool forceRefresh = false}) {
//     return ApiRequestBuilder<List<ProjectModel>>(
//       method: baseUrl.get.method,
//       path: ApiEndpoints.projects,
//       fromJson: (json) => (json as List)
//           .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     ).isCachingEnabled(true, 'projects_list').execute(forceRefresh: forceRefresh);
//   }

//   Future<ProjectModel> createProject(Map<String, dynamic> payload) {
//     return ApiRequestBuilder<ProjectModel>(
//       method: baseUrl.post.method,
//       path: ApiEndpoints.createProject,
//       data: payload,
//       fromJson: (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<ProjectModel> getProjectDetails(String projectId) {
//     return ApiRequestBuilder<ProjectModel>(
//       method: baseUrl.get.method,
//       path: ApiEndpoints.projectDetails(projectId),
//       fromJson: (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<ProjectModel> updateProject(String projectId, Map<String, dynamic> payload) {
//     return ApiRequestBuilder<ProjectModel>(
//       method: baseUrl.put.method,
//       path: ApiEndpoints.updateProject(projectId),
//       data: payload,
//       fromJson: (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<void> deleteProject(String projectId) {
//     return ApiRequestBuilder<void>(
//       method: baseUrl.delete.method,
//       path: ApiEndpoints.deleteProject(projectId),
//       fromJson: (_) {},
//     ).execute();
//   }

//   Future<double> getProjectProgress(String projectId) {
//     return ApiRequestBuilder<double>(
//       method: baseUrl.get.method,
//       path: ApiEndpoints.projectProgress(projectId),
//       fromJson: (json) => ((json as Map<String, dynamic>)['progress_percent'] as num)
//           .toDouble(),
//     ).execute();
//   }

//   Future<List<WorkforceRequirementModel>> getWorkforceRequirements(String projectId) {
//     return ApiRequestBuilder<List<WorkforceRequirementModel>>(
//       method: baseUrl.get.method,
//       path: ApiEndpoints.workforceRequirements(projectId),
//       fromJson: (json) => (json as List)
//           .map((e) => WorkforceRequirementModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     ).execute();
//   }

//   Future<WorkforceRequirementModel> postWorkforceRequirement(
//     String projectId,
//     Map<String, dynamic> payload,
//   ) {
//     return ApiRequestBuilder<WorkforceRequirementModel>(
//       method: baseUrl.post.method,
//       path: ApiEndpoints.postWorkforceRequirement(projectId),
//       data: payload,
//       fromJson: (json) =>
//           WorkforceRequirementModel.fromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<void> assignWorkerToProject(String projectId, String workerId) {
//     return ApiRequestBuilder<void>(
//       method: baseUrl.post.method,
//       path: ApiEndpoints.assignWorkerToProject(projectId),
//       data: {'worker_id': workerId},
//       fromJson: (_) {},
//     ).execute();
//   }
// }
