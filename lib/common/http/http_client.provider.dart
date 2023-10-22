import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client.provider.g.dart';

@Riverpod(keepAlive: true)
Dio httpClient(HttpClientRef ref) {
  final dio = Dio();

  ref.onDispose(() {
    dio.close();
  });

  // dio.interceptors.add(ApiAuthInterceptor());

  return dio;
}
