import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  final double salary;

  const SignUpWithEmailPasswordEvent({
    required this.email,
    required this.password,
    required this.salary,
  });

  @override
  List<Object?> get props => [email, password, salary];
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