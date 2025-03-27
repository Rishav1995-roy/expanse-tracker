import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  
  const Failure([this.properties = const <dynamic>[]]);
  
  @override
  List<Object?> get props => [properties];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

// Auth failures
class InvalidCredentialsFailure extends Failure {
  final String message;
  
  const InvalidCredentialsFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure();
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure();
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure();
} 