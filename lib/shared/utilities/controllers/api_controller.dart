import 'package:dio/dio.dart';

class ApiController {
  final _dio = Dio();

  Future<T> getRequest<T>(
      String url, T Function(Map<String, dynamic> json) factory,
      {Map<String, dynamic>? parameters}) async {
    final response = await _dio.get(url, queryParameters: parameters);
    final data = response.data;

    return factory(data);
  }
}
