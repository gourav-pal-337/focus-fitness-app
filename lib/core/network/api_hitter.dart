import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../constants/api_endpoints.dart';
import '../service/local_storage_service.dart';
import '../utils/app_utils.dart';
import '../../routes/app_router.dart';

/// API client for making HTTP requests
class ApiHitter {
  Dio? dio;
  static final ApiHitter singleton = ApiHitter._internal();

  factory ApiHitter() => singleton;

  ApiHitter._internal() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: Endpoints.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(milliseconds: 60000),
        receiveTimeout: const Duration(milliseconds: 60000),
      );
      dio = Dio(options)
        ..interceptors.addAll([
          LogInterceptor(request: false, requestBody: true, responseBody: true),
          _AccessTokenInterceptor(),
        ]);
    }
    if (!kIsWeb) {
      (dio!.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };
    }
  }

  Future<ApiResponse> getPostApiResponse(
    String endPoint, {

    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    bool value = await checkInternetConnection();
    if (value == false) {
      debugPrint('No internet connection');
    }

    if (value) {
      try {
        var response = await dio!.post(
          endPoint,

          queryParameters: queryParameters,
          data: data,
        );

        return apiData(response);
      } on DioException catch (error) {
        return exception(error);
      }
    } else {
      return ApiResponse(
        false,
        msg: 'Check your internet connection and Please try again later.',
      );
    }
  }

  Future<ApiResponse> getPutApiResponse(
    String endPoint, {

    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    bool value = await checkInternetConnection();
    if (value == false) {
      debugPrint('No internet connection');
    }

    if (value) {
      try {
        var response = await dio!.put(
          endPoint,
          queryParameters: queryParameters,

          data: data,
        );
        return apiData(response);
      } on DioException catch (error) {
        return exception(error);
      }
    } else {
      return ApiResponse(
        false,
        msg: 'Check your internet connection and Please try again later.',
      );
    }
  }

  Future<ApiResponse> getPatchApiResponse(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    bool value = await checkInternetConnection();
    if (value == false) {
      debugPrint('No internet connection');
    }

    if (value) {
      try {
        var response = await dio!.patch(
          endPoint,
          queryParameters: queryParameters,
          data: data,
        );
        return apiData(response);
      } on DioException catch (error) {
        return exception(error);
      }
    } else {
      return ApiResponse(
        false,
        msg: 'Check your internet connection and Please try again later.',
      );
    }
  }

  Future<ApiResponse> getApiResponse(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    bool value = await checkInternetConnection();
    if (value == false) {
      debugPrint('No internet connection');
    }

    if (value) {
      try {
        var response = await dio!.get(
          endPoint,
          queryParameters: queryParameters,
          data: data,
        );
        return apiData(response);
      } on DioException catch (error) {
        return exception(error);
      }
    } else {
      debugPrint('not connected');

      return ApiResponse(
        false,
        msg: 'Check your internet connection and Please try again later.',
      );
    }
  }

  Future<ApiResponse> deleteApiResponse(
    String endPoint, {
    Map<String, dynamic>? data,
  }) async {
    bool value = await checkInternetConnection();
    if (value == false) {
      debugPrint('No internet connection');
    }

    if (value) {
      try {
        var response = await dio!.delete(endPoint, data: data);
        return apiData(response);
      } on DioException catch (error) {
        return exception(error);
      }
    } else {
      return ApiResponse(
        false,
        msg: 'Check your internet connection and Please try again later.',
      );
    }
  }

  Future<MultipartFile> createMultipartFile(File file) async {
    String fileName = path.basename(file.path);
    String? mimeType = lookupMimeType(file.path);

    return MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    );
  }

  Future<List<MultipartFile>> createMultipartFiles(List<File> files) async {
    List<MultipartFile> multipartFiles = [];

    for (final file in files) {
      String fileName = path.basename(file.path);
      String? mimeType = lookupMimeType(file.path);

      multipartFiles.add(
        await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );
    }

    return multipartFiles;
  }

  ApiResponse exception(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        final path = e.requestOptions.path;
        final isAuthRequest =
            path.contains('/auth/login') ||
            path.contains('/auth/verify-otp') ||
            path.contains('/auth/firebase-login') ||
            path.contains('/auth/register');

        if (!isAuthRequest) {
          // Note: Token refresh is handled in the interceptor.
          // This method is called after the interceptor's onError (if it fails to refresh).
          String errorMessage = 'Something went wrong';
          if (e.response?.data is Map<String, dynamic>) {
            errorMessage =
                (e.response?.data['error'] ??
                        e.response?.data['msg'] ??
                        'Something went wrong')
                    .toString();
          }
          debugPrint(errorMessage);

          LocalStorageService.clearAll();
          AppRouter.router.go(OnboardingRoute.path);
        }
      }

      final responseData = e.response?.data;
      String errorMessage = e.message ?? 'An error occurred';

      if (responseData is Map<String, dynamic>) {
        errorMessage =
            responseData['error'] as String? ??
            responseData['message'] as String? ??
            responseData['msg'] as String? ??
            errorMessage;
      }

      return ApiResponse(false, msg: errorMessage, response: e.response);
    } else {
      return ApiResponse(
        false,
        msg: e.message ?? 'An error occurred',
        response: e.response,
      );
    }
  }

  ApiResponse apiData(Response<dynamic> response) {
    String message = 'Success';
    if (response.data is Map<String, dynamic>) {
      message = (response.data as Map<String, dynamic>)['message'] ?? 'Success';
    }
    return ApiResponse(
      response.statusCode == 200 || response.statusCode == 201,
      response: response,
      msg: message,
    );
  }

  Future<ApiResponse> downloadPdf(String url, String savePath) async {
    bool value = await checkInternetConnection();
    if (value == false) {
      debugPrint('No internet connection');
    }

    if (value) {
      try {
        var response = await Dio().download(
          url,
          savePath,
          options: Options(
            headers: {'Accept': '*/*'},
            followRedirects: false,
            responseType: ResponseType.bytes,
          ),
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final progress = (received / total * 100).toStringAsFixed(0);
              debugPrint('Download Progress: $progress%');
            }
          },
        );

        return ApiResponse(
          response.statusCode == 200,
          msg: response.statusCode == 200
              ? 'PDF downloaded successfully'
              : 'Failed to download PDF',
          response: response,
        );
      } on DioException catch (error) {
        return exception(error);
      }
    } else {
      return ApiResponse(
        false,
        msg: 'Check your internet connection and Please try again later.',
      );
    }
  }

  Future<ApiResponse> uploadFile({
    Map<String, dynamic>? body,
    required File file,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (body != null) ...body,
        'file': await MultipartFile.fromFile(file.path),
      });
      log("the upload function  ${formData}");

      final response = await dio!.post(Endpoints.uploadFile, data: formData);
      return apiData(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 502) {
        return exception(e);
      }
      if (e.response != null) {
        return exception(e);
      } else {
        return exception(e);
      }
    } catch (e) {
      log("catch " + e.toString());
      return exception(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error': 'Unable to connect to server'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }

  Future<ApiResponse> uploadXFile({
    Map<String, dynamic>? body,
    required XFile file,
  }) async {
    try {
      MultipartFile multipartFile;

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: file.name,
          contentType: MediaType.parse(
            lookupMimeType(file.name) ?? 'application/octet-stream',
          ),
        );
      } else {
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.name,
          contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream',
          ),
        );
      }

      final formData = FormData.fromMap({
        if (body != null) ...body,
        'file': multipartFile,
      });

      final response = await dio!.post(Endpoints.uploadFile, data: formData);
      return apiData(response);
    } on DioException catch (e) {
      return exception(e);
    } catch (e) {
      log("catch " + e.toString());
      return exception(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error': 'Unable to connect to server'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }
}

class _AccessTokenInterceptor extends Interceptor {
  static bool _isRefreshing = false;
  static List<Map<String, dynamic>> _failedRequests = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorageService.getToken();
    log("User token is: ${token ?? ''}");
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic> &&
        (response.data as Map<String, dynamic>).containsKey('message')) {
      // Success message handling can be added here if needed
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException exception, ErrorInterceptorHandler handler) async {
    final response = exception.response;
    if (response != null && response.statusCode == 401) {
      final path = exception.requestOptions.path;
      final isAuthRequest =
          path.contains('/auth/login') ||
          path.contains('/auth/verify-otp') ||
          path.contains('/auth/firebase-login') ||
          path.contains('/auth/register') ||
          path.contains('/auth/refresh-token');

      if (!isAuthRequest) {
        if (_isRefreshing) {
          // If already refreshing, queue this request
          log("Refresh already in progress, queuing request: ${exception.requestOptions.path}");
          return _retryRequestOnCompletion(exception, handler);
        }

        _isRefreshing = true;
        final refreshToken = await LocalStorageService.getRefreshToken();
        if (refreshToken.isNotEmpty) {
          try {
            log("Attempting to refresh token...");
            final refreshDio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
            final refreshResponse = await refreshDio.post(
              Endpoints.refreshToken,
              data: {'refreshToken': refreshToken},
            );

            if (refreshResponse.statusCode == 200 ||
                refreshResponse.statusCode == 201) {
              final newAccessToken =
                  refreshResponse.data['accessToken'] ??
                  refreshResponse.data['tokens']['accessToken'];
              final newRefreshToken =
                  refreshResponse.data['refreshToken'] ??
                  refreshResponse.data['tokens']['refreshToken'];

              if (newAccessToken != null) {
                log("Token refreshed successfully!");
                await LocalStorageService.setToken(newAccessToken);
                if (newRefreshToken != null) {
                  await LocalStorageService.setRefreshToken(newRefreshToken);
                }

                _isRefreshing = false;
                _resolveQueue(newAccessToken);

                // Retry the current request
                return _retryRequest(exception.requestOptions, newAccessToken, handler);
              }
            }
          } catch (e) {
            log("Refresh token failed: $e");
            _isRefreshing = false;
            _failedRequests.clear();
            // Fall through to default error handling (logout)
          }
        } else {
          _isRefreshing = false;
        }
      }
    }
    super.onError(exception, handler);
  }

  void _resolveQueue(String newToken) {
    log("Resolving queued requests: ${_failedRequests.length}");
    for (var request in _failedRequests) {
      final options = request['options'] as RequestOptions;
      final handler = request['handler'] as ErrorInterceptorHandler;
      _retryRequest(options, newToken, handler);
    }
    _failedRequests.clear();
  }

  Future<void> _retryRequestOnCompletion(
    DioException exception,
    ErrorInterceptorHandler handler,
  ) async {
    _failedRequests.add({
      'options': exception.requestOptions,
      'handler': handler,
    });
  }

  Future<void> _retryRequest(
    RequestOptions options,
    String newToken,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $newToken';
    try {
      final retryResponse = await ApiHitter.singleton.dio!.fetch(options);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.reject(e is DioException ? e : DioException(requestOptions: options, error: e));
    }
  }
}

class ApiResponse {
  final bool status;
  final String msg;
  final Response? response;

  ApiResponse(this.status, {this.msg = 'Success', this.response});
}
