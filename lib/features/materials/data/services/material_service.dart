import 'package:contractor_app/core/config/app_config.dart';
import 'package:contractor_app/core/network/api_client.dart';
import 'package:contractor_app/core/network/api_endpoints.dart';
import 'package:contractor_app/core/network/api_request_builder.dart';
import '../models/material_usage_model.dart';
import '../mock/materials_mock.dart';

class MaterialService {
  MaterialService._();
  static final instance = MaterialService._();

  /// Material consumption across projects (requested vs used).
  Future<List<MaterialUsageModel>> getMaterialUsage({bool forceRefresh = false}) {
    if (AppConfig.mockMode) return Future.value(List.of(MaterialsMock.usage));
    return ApiRequestBuilder<List<MaterialUsageModel>>(
      method: baseUrl.get.method,
      path: ApiEndpoints.materialUsage,
      fromJson: (json) => (json as List)
          .map((e) => MaterialUsageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ).isCachingEnabled(true, 'material_usage').execute(forceRefresh: forceRefresh);
  }

  Future<void> raiseMaterialRequest(Map<String, dynamic> payload) {
    if (AppConfig.mockMode) return Future.value();
    return ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.raiseMaterialRequest,
      data: payload,
      fromJson: (_) {},
    ).execute();
  }

  Future<void> logMaterialUsage(Map<String, dynamic> payload) {
    if (AppConfig.mockMode) return Future.value();
    return ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.logMaterialUsage,
      data: payload,
      fromJson: (_) {},
    ).execute();
  }
}