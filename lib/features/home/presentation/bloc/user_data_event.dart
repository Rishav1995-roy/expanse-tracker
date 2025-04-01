import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object?> get props => [];
}

class SaveUserSalaryEvent extends UserDataEvent {
  final String userId;
  final double salary;
  final String fcmToken;

  const SaveUserSalaryEvent({
    required this.userId,
    required this.salary,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [userId, salary, fcmToken];
}

class UpdateUserSalaryEvent extends UserDataEvent {
  final String userId;
  final double salary;

  const UpdateUserSalaryEvent({
    required this.userId,
    required this.salary,
  });

  @override
  List<Object?> get props => [userId, salary];
}

class SaveUserFcmTokenEvent extends UserDataEvent {
  final String userId;
  final String fcmToken;

  const SaveUserFcmTokenEvent({
    required this.userId,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [userId, fcmToken];
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
  final String dueDate;

  const SaveExpenseEvent({
    required this.userId,
    required this.category,
    required this.amount,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [userId, category, amount, dueDate];
}

class UpdateExpenseEvent extends UserDataEvent {
  final String userId;
  final String category;
  final double amount;
  final String dueDate;

  const UpdateExpenseEvent({
    required this.userId,
    required this.category,
    required this.amount,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [userId, category, amount, dueDate];
}

class DeleteExpenseEvent extends UserDataEvent {
  final String userId;
  final String category;

  const DeleteExpenseEvent({
    required this.userId,
    required this.category,
  });

  @override
  List<Object?> get props => [userId, category];
}

class LoadUserDataEvent extends UserDataEvent {
  final String userId;

  const LoadUserDataEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
} 