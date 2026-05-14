import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio_api_products/core/helpers/http_response.dart';

class BaseHttpDio {
  final Dio dio;

  BaseHttpDio(this.dio);

  Future<HttpResponse<T>> resquest<T>(
    String pathUrl, {
    method = "GET",
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await dio.request(
        pathUrl,
        data: data,
        options: Options(method: method, headers: headers),
      );

      if (parser != null) {
        return HttpResponse.success<T>(parser(response.data));
      }
      return HttpResponse.success(response.data);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      int statusCode = 0;
      String message = 'error without name';
      dynamic data;

      if (e is DioException) {
        statusCode = -1;
        if (e.response != null) {
          statusCode = e.response!.statusCode ?? 0;
          message = e.response!.statusMessage ?? 'error without name';
          data = e.response!.data;
        }
      }

      return HttpResponse.fail(statusCode, message, data);
    }
  }
}
