import 'api_request_builder.dart';

class ApiMethodBuilder {
  const ApiMethodBuilder(this.method);
  final HttpMethod method;
}

class ApiClient {
  const ApiClient._();
  ApiMethodBuilder get get => const ApiMethodBuilder(HttpMethod.get);
  ApiMethodBuilder get post => const ApiMethodBuilder(HttpMethod.post);
  ApiMethodBuilder get put => const ApiMethodBuilder(HttpMethod.put);
  ApiMethodBuilder get delete => const ApiMethodBuilder(HttpMethod.delete);
}

const baseUrl = ApiClient._();