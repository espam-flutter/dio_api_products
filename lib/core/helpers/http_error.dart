class HttpError {
  final int statusCode;
  final String message;
  final dynamic data;

  HttpError(this.statusCode, this.message, this.data);
}
