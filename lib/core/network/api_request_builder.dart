import 'api_service.dart';

enum HttpMethod { get, post, put, patch, delete }

class ApiRequestBuilder<T> {
  ApiRequestBuilder({
    required this.method,
    required this.path,
    required this.fromJson,
    this.data,
    this.queryParameters,
  });

  final HttpMethod method;
  final String path;
  final T Function(dynamic json) fromJson;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;

  bool cachingEnabled = false;
  String? cacheKey;

  ApiRequestBuilder<T> isCachingEnabled(bool enabled, [String? key]) {
    cachingEnabled = enabled;
    cacheKey = key;
    return this;
  }

  Future<T> execute({bool forceRefresh = false}) =>
      ApiService.instance.send<T>(this, forceRefresh: forceRefresh);
}