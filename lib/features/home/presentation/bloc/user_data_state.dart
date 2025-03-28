import 'package:equatable/equatable.dart';
import '../../data/models/expense_model.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object?> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataSaved extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final double? salary;
  final Map<String, ExpenseModel> expenses;

  const UserDataLoaded({
    this.salary,
    this.expenses = const {},
  });

  @override
  List<Object?> get props => [salary, expenses];
}

class UserTokenLoaded extends UserDataState {
  final String? token;

  const UserTokenLoaded({
    this.token,
  });

  @override
  List<Object?> get props => [token];
}

class UserDataError extends UserDataState {
  final String message;

  const UserDataError(this.message);

  @override
  List<Object?> get props => [message];
} 