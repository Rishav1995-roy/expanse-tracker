import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../../data/models/user_data_model.dart';

abstract class UserDataRepository {
  Future<Either<Failure, void>> saveUserSalary(String userId, double salary);
  Future<Either<Failure, double>> loadUserSalary(String userId);
  Future<Either<Failure, void>> saveExpense(String userId, String category, double amount);
  Future<Either<Failure, UserDataModel>> loadUserData(String userId);
} 