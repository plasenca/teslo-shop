class WrongCredentials implements Exception {}

class Invalidtoken implements Exception {}

class ConnectionTimeOut implements Exception {}

class TokenNotValid implements Exception {}

class TokenNotFound implements Exception {}

class CustomError implements Exception {
  final String? message;
  final int statusCode;

  CustomError({
    required this.statusCode,
    this.message,
  });
}
