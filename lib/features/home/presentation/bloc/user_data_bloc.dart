import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_data_model.dart';
import '../../domain/usecases/load_user_data.dart';
import '../../domain/usecases/load_user_salary.dart';
import '../../domain/usecases/save_expense.dart';
import '../../domain/usecases/save_user_salary.dart';
import 'user_data_event.dart';
import 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final SaveUserSalary saveUserSalary;
  final LoadUserSalary loadUserSalary;
  final SaveExpense saveExpense;
  final LoadUserData loadUserData;

  UserDataBloc({
    required this.saveUserSalary,
    required this.loadUserSalary,
    required this.saveExpense,
    required this.loadUserData,
  }) : super(UserDataInitial()) {
    on<SaveUserSalaryEvent>(_onSaveUserSalary);
    on<LoadUserSalaryEvent>(_onLoadUserSalary);
    on<SaveExpenseEvent>(_onSaveExpense);
    on<LoadUserDataEvent>(_onLoadUserData);
  }

  Future<void> _onSaveUserSalary(
    SaveUserSalaryEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    
    final result = await saveUserSalary(event.userId, event.salary);
    
    result.fold(
      (failure) => emit(UserDataError('Failed to save salary')),
      (_) => emit(UserDataLoaded(salary: event.salary)),
    );
  }

  Future<void> _onLoadUserSalary(
    LoadUserSalaryEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    
    final result = await loadUserSalary(event.userId);
    
    result.fold(
      (failure) => emit(UserDataError('Failed to load salary')),
      (salary) => emit(UserDataLoaded(salary: salary)),
    );
  }
  
  Future<void> _onSaveExpense(
    SaveExpenseEvent event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    
    final result = await saveExpense(event.userId, event.category, event.amount);
    
    result.fold(
      (failure) => emit(UserDataError('Failed to save expense')),
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
      (failure) => emit(UserDataError('Failed to load user data')),
      (userData) => emit(UserDataLoaded(
        salary: userData.salary,
        expenses: userData.expenses,
      )),
    );
  }
} 