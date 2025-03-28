import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  final String fcmToken;

  const SignInWithEmailPasswordEvent({
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [email, password, fcmToken];
}

class SignUpWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  final double salary;
  final String fcmToken;

  const SignUpWithEmailPasswordEvent({
    required this.email,
    required this.password,
    required this.salary,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [email, password, salary, fcmToken,];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();

  @override
  List<Object?> get props => [];
} 