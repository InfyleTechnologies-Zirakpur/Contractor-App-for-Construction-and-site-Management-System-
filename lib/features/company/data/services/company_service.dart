import 'package:contractor_app/core/config/app_config.dart';
import 'package:contractor_app/core/network/api_client.dart';
import 'package:contractor_app/core/network/api_endpoints.dart';
import 'package:contractor_app/core/network/api_request_builder.dart';
import '../models/company_model.dart';
import '../mock/company_mock.dart';

class CompanyService {
  CompanyService._();
  static final instance = CompanyService._();

  /// Returns null when the company isn't registered yet.
  Future<CompanyModel?> getCompany({bool forceRefresh = false}) async {
    if (AppConfig.mockMode) return CompanyMock.company;
    return ApiRequestBuilder<CompanyModel?>(
      method: baseUrl.get.method,
      path: ApiEndpoints.companyProfile,
      fromJson: (json) {
        final company = (json as Map<String, dynamic>)['company'];
        return company == null
            ? null
            : CompanyModel.fromJson(company as Map<String, dynamic>);
      },
    ).isCachingEnabled(true, 'company_profile').execute(forceRefresh: forceRefresh);
  }

  Future<CompanyModel> registerCompany(CompanyModel company) {
    if (AppConfig.mockMode) {
      return Future.value(CompanyMock.save(company));
    }
    return ApiRequestBuilder<CompanyModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.registerCompany,
      data: company.toJson(),
      fromJson: (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  Future<CompanyModel> updateProfile(CompanyModel company) {
    if (AppConfig.mockMode) {
      return Future.value(CompanyMock.save(company));
    }
    return ApiRequestBuilder<CompanyModel>(
      method: baseUrl.put.method,
      path: ApiEndpoints.updateCompanyProfile,
      data: company.toJson(),
      fromJson: (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  Future<VerificationStatus> getVerificationStatus() async {
    if (AppConfig.mockMode) return CompanyMock.company.verificationStatus;
    return ApiRequestBuilder<VerificationStatus>(
      method: baseUrl.get.method,
      path: ApiEndpoints.companyVerificationStatus,
      fromJson: (json) => _statusFromJson(json as Map<String, dynamic>),
    ).execute();
  }

  /// Submits KYC/registration documents for the verification process.
  Future<void> submitVerification(Map<String, dynamic> payload) async {
    if (AppConfig.mockMode) return;
    return ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.submitCompanyVerification,
      data: payload,
      fromJson: (_) {},
    ).execute();
  }

  VerificationStatus _statusFromJson(Map<String, dynamic> json) {
    switch (json['status']) {
      case 'approved':
        return VerificationStatus.approved;
      case 'rejected':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.pending;
    }
  }
}