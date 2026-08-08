import 'package:dio/dio.dart';
import 'api_cache_store.dart';
import 'api_request_builder.dart';
import 'header_interceptor.dart';

class ApiService {
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.yourbackend.com', // TODO(you): real base URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    _dio.interceptors.add(HeaderInterceptor());
  }

  static final ApiService instance = ApiService._internal();
  late final Dio _dio;
  final _cache = ApiCacheStore();

  Future<T> send<T>(ApiRequestBuilder<T> builder, {bool forceRefresh = false}) async {
    if (builder.cachingEnabled && builder.cacheKey != null && !forceRefresh) {
      final cachedJson = await _cache.read(builder.cacheKey!);
      if (cachedJson != null) return builder.fromJson(cachedJson);
    }

    final response = await _dio.request(
      builder.path,
      data: builder.data,
      queryParameters: builder.queryParameters,
      options: Options(method: builder.method.name.toUpperCase()),
    );

    if (builder.cachingEnabled && builder.cacheKey != null) {
      await _cache.write(builder.cacheKey!, response.data);
    }

    return builder.fromJson(response.data);
  }
}