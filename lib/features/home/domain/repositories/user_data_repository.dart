import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../../data/models/user_data_model.dart';

abstract class UserDataRepository {
  Future<Either<Failure, void>> saveUserSalary(String userId, double salary, String fcmToken);
  Future<Either<Failure, void>> saveUserToken(String userId, String fcmToken);
  Future<Either<Failure, double>> loadUserSalary(String userId);
  Future<Either<Failure, void>> saveExpense(String userId, String category, double amount, String dueDate);
  Future<Either<Failure, UserDataModel>> loadUserData(String userId);
} 