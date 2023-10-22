import 'package:dio/dio.dart';

class ApiV1AuthInterceptor extends Interceptor {
  const ApiV1AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.headers['authorization'] = 'Basic $basicAuth';
    super.onRequest(options, handler);
  }
}
