import 'package:dio_api_products/core/helpers/http_error.dart';

class HttpResponse<T> {
  final T? data;
  final HttpError? error;

  HttpResponse(this.data, this.error);

  static HttpResponse<T> success<T>(T data) => HttpResponse(data, null);

  static HttpResponse<T> fail<T>(
    int statusCode,
    String message,
    dynamic data,
  ) => HttpResponse(null, HttpError(statusCode, message, data));
}
