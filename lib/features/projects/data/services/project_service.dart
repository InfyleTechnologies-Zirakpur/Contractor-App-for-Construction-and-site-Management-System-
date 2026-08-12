import 'package:contractor_app/core/config/app_config.dart';
import 'package:contractor_app/core/network/api_client.dart';
import 'package:contractor_app/core/network/api_endpoints.dart';
import 'package:contractor_app/core/network/api_request_builder.dart';
import '../models/project_model.dart';
import '../mock/projects_mock.dart';

class ProjectService {
  ProjectService._();
  static final instance = ProjectService._();

  Future<List<ProjectModel>> getProjects({bool forceRefresh = false}) {
    if (AppConfig.mockMode) return Future.value(List.of(ProjectsMock.projects));
    return ApiRequestBuilder<List<ProjectModel>>(
      method: baseUrl.get.method,
      path: ApiEndpoints.projects,
      fromJson: (json) => (json as List)
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ).isCachingEnabled(true, 'projects_list').execute(forceRefresh: forceRefresh);
  }

  Future<ProjectModel> createProject(Map<String, dynamic> payload) {
    if (AppConfig.mockMode) return Future.value(ProjectsMock.fromPayload(payload));
    return ApiRequestBuilder<ProjectModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.createProject,
      data: payload,
      fromJson: (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  Future<ProjectModel> getProjectDetails(String projectId) {
    if (AppConfig.mockMode) {
      return Future.value(
        ProjectsMock.projects.firstWhere(
          (p) => p.id == projectId,
          orElse: () => ProjectsMock.projects.first,
        ),
      );
    }
    return ApiRequestBuilder<ProjectModel>(
      method: baseUrl.get.method,
      path: ApiEndpoints.projectDetails(projectId),
      fromJson: (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  Future<ProjectModel> updateProject(String projectId, Map<String, dynamic> payload) {
    if (AppConfig.mockMode) return Future.value(ProjectsMock.fromPayload(payload));
    return ApiRequestBuilder<ProjectModel>(
      method: baseUrl.put.method,
      path: ApiEndpoints.updateProject(projectId),
      data: payload,
      fromJson: (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  Future<void> deleteProject(String projectId) {
    if (AppConfig.mockMode) return Future.value();
    return ApiRequestBuilder<void>(
      method: baseUrl.delete.method,
      path: ApiEndpoints.deleteProject(projectId),
      fromJson: (_) {},
    ).execute();
  }

  Future<double> getProjectProgress(String projectId) {
    if (AppConfig.mockMode) {
      return Future.value(
        ProjectsMock.projects
            .firstWhere((p) => p.id == projectId, orElse: () => ProjectsMock.projects.first)
            .progressPercent,
      );
    }
    return ApiRequestBuilder<double>(
      method: baseUrl.get.method,
      path: ApiEndpoints.projectProgress(projectId),
      fromJson: (json) =>
          ((json as Map<String, dynamic>)['progress_percent'] as num).toDouble(),
    ).execute();
  }

  Future<List<WorkforceRequirementModel>> getWorkforceRequirements(
    String projectId,
  ) {
    if (AppConfig.mockMode) {
      return Future.value(ProjectsMock.requirementsFor(projectId));
    }
    return ApiRequestBuilder<List<WorkforceRequirementModel>>(
      method: baseUrl.get.method,
      path: ApiEndpoints.workforceRequirements(projectId),
      fromJson: (json) => (json as List)
          .map((e) => WorkforceRequirementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ).execute();
  }

  Future<WorkforceRequirementModel> postWorkforceRequirement(
    String projectId,
    Map<String, dynamic> payload,
  ) {
    if (AppConfig.mockMode) {
      return Future.value(
        WorkforceRequirementModel(
          id: '$projectId-wx',
          role: payload['role'] as String,
          count: payload['count'] as int,
          neededBy: DateTime.parse(payload['needed_by'] as String),
        ),
      );
    }
    return ApiRequestBuilder<WorkforceRequirementModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.postWorkforceRequirement(projectId),
      data: payload,
      fromJson: (json) =>
          WorkforceRequirementModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  Future<void> assignWorkerToProject(String projectId, String workerId) {
    if (AppConfig.mockMode) return Future.value();
    return ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.assignWorkerToProject(projectId),
      data: {'worker_id': workerId},
      fromJson: (_) {},
    ).execute();
  }
}