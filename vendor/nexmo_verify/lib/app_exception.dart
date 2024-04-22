class AppException extends StateError {
  int statusCode;

  AppException(String msg, this.statusCode) : super(msg);
}
