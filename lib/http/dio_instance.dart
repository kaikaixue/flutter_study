import 'package:dio/dio.dart';
import 'package:flutter_study/http/cookie_interceptor.dart';
import 'package:flutter_study/http/http_method.dart';
import 'package:flutter_study/http/print_log_interceptor.dart';
import 'package:flutter_study/http/rsp_interceptor.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._();

  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTime = const Duration(seconds: 30);

  void initDio({
    String? httpMethod = HttpMethod.GET,
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) {
    _dio.options = BaseOptions(
      method: httpMethod,
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? _defaultTime,
      receiveTimeout: receiveTimeout ?? _defaultTime,
      sendTimeout: sendTimeout ?? _defaultTime,
      responseType: responseType,
      contentType: contentType,
    );
    _dio.interceptors.add(CookieInterceptor());
    _dio.interceptors.add(PrintLogInterceptor());
    _dio.interceptors.add(ResponseInterceptor());
  }

  Future<Response> get({required String path,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken}) async {
    return await _dio.get(path,
        queryParameters: params,
        options: options ??
            Options(
                method: HttpMethod.GET,
                receiveTimeout: _defaultTime,
                sendTimeout: _defaultTime),
        cancelToken: cancelToken);
  }

  Future<Response> post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken
  }) async {
    return await _dio.post(path, queryParameters: queryParameters,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(method: HttpMethod.POST, receiveTimeout: _defaultTime, sendTimeout: _defaultTime));
  }
}
