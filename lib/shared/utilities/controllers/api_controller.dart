import 'package:dio/dio.dart';

class ApiController {
  final _dio = Dio();

  Future<T> getRawRequest<T>(String url,
      {Map<String, dynamic>? parameters}) async {
    final response = await _dio.get(url, queryParameters: parameters);
    return response.data;
  }

  Future<T> getRequest<T>(
      String url, T Function(Map<String, dynamic> json) factory,
      {Map<String, dynamic>? parameters}) async {
    final response = await _dio.get(url, queryParameters: parameters);
    final data = response.data;
    return factory(data);
  }

  Future<List<T>?> getRequestList<T>(
      String url, T Function(Map<String, dynamic> json) factory,
      {Map<String, dynamic>? parameters, String? listKey}) async {
    final response = await _dio.get(url, queryParameters: parameters);
    final Map<String, dynamic> dataMap = response.data;

    if (!dataMap.containsKey(listKey)) {
      return null;
    }

    final List<dynamic> data = response.data[listKey] ?? response.data;
    return data.map((json) => factory(json)).toList();
  }
}
