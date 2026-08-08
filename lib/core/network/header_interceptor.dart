import 'package:dio/dio.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isMultipart = options.data is FormData;
    options.headers['Content-Type'] =
        isMultipart ? 'multipart/form-data' : 'application/json';
    options.headers['Accept'] = 'application/json';

    final token = AuthTokenStore.instance.token;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';

    handler.next(options);
  }
}

class AuthTokenStore {
  AuthTokenStore._();
  static final instance = AuthTokenStore._();
  String? token;
}