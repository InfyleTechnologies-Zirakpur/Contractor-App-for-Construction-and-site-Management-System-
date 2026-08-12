import 'package:contractor_app/core/config/app_config.dart';
import 'package:contractor_app/core/network/api_client.dart';
import 'package:contractor_app/core/network/api_endpoints.dart';
import 'package:contractor_app/core/network/api_request_builder.dart';
import '../models/job_model.dart';
import '../mock/jobs_mock.dart';

class RecruitmentService {
  RecruitmentService._();
  static final instance = RecruitmentService._();

  /// Jobs posted by the current contractor.
  Future<List<JobModel>> getPostedJobs({bool forceRefresh = false}) {
    if (AppConfig.mockMode) return Future.value(List.of(JobsMock.jobs));
    return ApiRequestBuilder<List<JobModel>>(
      method: baseUrl.get.method,
      path: ApiEndpoints.postedJobs,
      fromJson: (json) => (json as List)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ).isCachingEnabled(true, 'posted_jobs').execute(forceRefresh: forceRefresh);
  }

  Future<JobModel> postJob(Map<String, dynamic> payload) {
    if (AppConfig.mockMode) return Future.value(JobsMock.fromPayload(payload));
    return ApiRequestBuilder<JobModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.postJob,
      data: payload,
      fromJson: (json) => JobModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }
}