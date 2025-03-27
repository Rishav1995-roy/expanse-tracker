class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class AuthException implements Exception {
  final String message;
  
  AuthException(this.message);
}

class InvalidCredentialsException implements Exception {
  final String message;
  
  InvalidCredentialsException(this.message);
}

class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

class UserNotFoundException implements Exception {} 