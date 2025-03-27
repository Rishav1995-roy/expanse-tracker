import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../datasources/user_data_remote_data_source.dart';
import '../models/user_data_model.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  final UserDataRemoteDataSource remoteDataSource;

  UserDataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> saveUserSalary(String userId, double salary) async {
    return await remoteDataSource.saveUserSalary(userId, salary);
  }

  @override
  Future<Either<Failure, double>> loadUserSalary(String userId) async {
    return await remoteDataSource.loadUserSalary(userId);
  }
  
  @override
  Future<Either<Failure, void>> saveExpense(String userId, String category, double amount) async {
    return await remoteDataSource.saveExpense(userId, category, amount);
  }
  
  @override
  Future<Either<Failure, UserDataModel>> loadUserData(String userId) async {
    return await remoteDataSource.loadUserData(userId);
  }
} 