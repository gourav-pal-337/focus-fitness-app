import '../../../core/network/api_hitter.dart';

class BaseService {
  BaseService({ApiHitter? apiHitter}) : _apiHitter = apiHitter ?? ApiHitter();

  final ApiHitter _apiHitter;

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiHitter.getApiResponse(
      endpoint,
      queryParameters: queryParameters,
    );

    if (!response.status || response.response == null) {
      throw Exception(response.msg);
    }

    final data = response.response!.data;
    if (data is Map<String, dynamic>) {
      return data;
    }

    return {'data': data};
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiHitter.getPostApiResponse(
      endpoint,
      data: body,
      queryParameters: queryParameters,
    );

    if (!response.status || response.response == null) {
      throw Exception(response.msg);
    }

    final data = response.response!.data;
    if (data is Map<String, dynamic>) {
      return data;
    }

    return {'data': data};
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _apiHitter.deleteApiResponse(endpoint, data: body);

    if (!response.status || response.response == null) {
      throw Exception(response.msg);
    }

    final data = response.response!.data;
    if (data is Map<String, dynamic>) {
      return data;
    }

    return {'data': data};
  }
}
