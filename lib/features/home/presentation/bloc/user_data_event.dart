import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object?> get props => [];
}

class SaveUserSalaryEvent extends UserDataEvent {
  final String userId;
  final double salary;

  const SaveUserSalaryEvent({
    required this.userId,
    required this.salary,
  });

  @override
  List<Object?> get props => [userId, salary];
}

class LoadUserSalaryEvent extends UserDataEvent {
  final String userId;

  const LoadUserSalaryEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class SaveExpenseEvent extends UserDataEvent {
  final String userId;
  final String category;
  final double amount;

  const SaveExpenseEvent({
    required this.userId,
    required this.category,
    required this.amount,
  });

  @override
  List<Object?> get props => [userId, category, amount];
}

class LoadUserDataEvent extends UserDataEvent {
  final String userId;

  const LoadUserDataEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
} 