import 'package:expanse_tracker_app/features/home/domain/usecases/delete_user_expanse.dart';
import 'package:expanse_tracker_app/features/home/domain/usecases/save_fcm_token.dart';
import 'package:expanse_tracker_app/features/home/domain/usecases/update_user_expanse.dart';
import 'package:expanse_tracker_app/features/home/domain/usecases/update_user_salary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/load_user_data.dart';
import '../../domain/usecases/load_user_salary.dart';
import '../../domain/usecases/save_expense.dart';
import '../../domain/usecases/save_user_salary.dart';
import 'user_data_event.dart';
import 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final SaveUserSalary saveUserSalary;
  final SaveFcmToken saveFcmToken;
  final LoadUserSalary loadUserSalary;
  final SaveExpense saveExpense;
  final LoadUserData loadUserData;
  final UpdateUserSalary updateUserSalary;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;

  UserDataBloc({
    required this.saveUserSalary,
    required this.loadUserSalary,
    required this.saveFcmToken,
    required this.saveExpense,
    required this.loadUserData,
    required this.updateUserSalary,
    required this.updateExpense,
    required this.deleteExpense,
  }) : super(UserDataInitial()) {
    on<SaveUserSalaryEvent>(_onSaveUserSalary);
    on<LoadUserSalaryEvent>(_onLoadUserSalary);
    on<SaveExpenseEvent>(_onSaveExpense);
    on<LoadUserDataEvent>(_onLoadUserData);
    on<SaveUserFcmTokenEvent>(_onSaveUserToken);
    on<UpdateUserSalaryEvent>(_onUpdateUserSalary);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onSaveUserToken(
    SaveUserFcmTokenEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await saveFcmToken(event.userId, event.fcmToken);

    result.fold(
      (failure) => emit(const UserDataError('Failed to save salary')),
      (_) => emit(UserTokenLoaded(token: event.fcmToken)),
    );
  }

  Future<void> _onSaveUserSalary(
    SaveUserSalaryEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result =
        await saveUserSalary(event.userId, event.salary, event.fcmToken);

    result.fold(
      (failure) => emit(const UserDataError('Failed to save salary')),
      (_) => emit(UserDataLoaded(salary: event.salary)),
    );
  }

  Future<void> _onUpdateUserSalary(
    UpdateUserSalaryEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await updateUserSalary(event.userId, event.salary);

    result.fold(
      (failure) => emit(const UserDataError('Failed to update salary')),
      (_) => emit(
        UserDataLoaded(
          salary: event.salary,
        ),
      ),
    );
  }

  Future<void> _onLoadUserSalary(
    LoadUserSalaryEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await loadUserSalary(event.userId);

    result.fold(
      (failure) => emit(const UserDataError('Failed to load salary')),
      (salary) => emit(UserDataLoaded(salary: salary)),
    );
  }

  Future<void> _onSaveExpense(
    SaveExpenseEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await saveExpense(
        event.userId, event.category, event.amount, event.dueDate);

    result.fold(
      (failure) => emit(const UserDataError('Failed to save expense')),
      (_) {
        emit(UserDataSaved());
      },
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await updateExpense(
        event.userId, event.category, event.amount, event.dueDate);

    result.fold(
      (failure) => emit(const UserDataError('Failed to update expense')),
      (_) {
        emit(UserDataSaved());
      },
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await deleteExpense(event.userId, event.category);

    result.fold(
      (failure) => emit(const UserDataError('Failed to delete expense')),
      (_) {
        emit(UserDataSaved());
      },
    );
  }

  Future<void> _onLoadUserData(
    LoadUserDataEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());

    final result = await loadUserData(event.userId);

    result.fold(
      (failure) => emit(const UserDataError('Failed to load user data')),
      (userData) => emit(UserDataLoaded(
        salary: userData.salary,
        expenses: userData.expenses,
      )),
    );
  }
}
