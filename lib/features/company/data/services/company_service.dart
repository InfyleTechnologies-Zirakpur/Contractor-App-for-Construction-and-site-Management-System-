// import '../../../../core/api/api_client.dart';
// import '../../../../core/api/api_endpoints.dart';
// import '../../../../core/api/api_request_builder.dart';
// import '../models/company_model.dart';

// class CompanyService {
//   CompanyService._();
//   static final instance = CompanyService._();

//   Future<CompanyModel> registerCompany(Map<String, dynamic> payload) {
//     return ApiRequestBuilder<CompanyModel>(
//       method: baseUrl.post.method,
//       path: ApiEndpoints.registerCompany,
//       data: payload,
//       fromJson: (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<CompanyModel> getProfile({bool forceRefresh = false}) {
//     return ApiRequestBuilder<CompanyModel>(
//       method: baseUrl.get.method,
//       path: ApiEndpoints.companyProfile,
//       fromJson: (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
//     ).isCachingEnabled(true, 'company_profile').execute(forceRefresh: forceRefresh);
//   }

//   Future<CompanyModel> updateProfile(Map<String, dynamic> payload) {
//     return ApiRequestBuilder<CompanyModel>(
//       method: baseUrl.put.method,
//       path: ApiEndpoints.updateCompanyProfile,
//       data: payload,
//       fromJson: (json) => CompanyModel.fromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<VerificationStatus> getVerificationStatus() {
//     return ApiRequestBuilder<VerificationStatus>(
//       method: baseUrl.get.method,
//       path: ApiEndpoints.companyVerificationStatus,
//       fromJson: (json) => _statusFromJson(json as Map<String, dynamic>),
//     ).execute();
//   }

//   Future<void> submitVerification(Map<String, dynamic> payload) {
//     return ApiRequestBuilder<void>(
//       method: baseUrl.post.method,
//       path: ApiEndpoints.submitCompanyVerification,
//       data: payload,
//       fromJson: (_) {},
//     ).execute();
//   }

//   VerificationStatus _statusFromJson(Map<String, dynamic> json) {
//     switch (json['status']) {
//       case 'approved':
//         return VerificationStatus.approved;
//       case 'rejected':
//         return VerificationStatus.rejected;
//       default:
//         return VerificationStatus.pending;
//     }
//   }
// }
