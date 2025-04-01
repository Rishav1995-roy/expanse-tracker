import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../repositories/user_data_repository.dart';

class UpdateExpense {
  final UserDataRepository repository;

  UpdateExpense(this.repository);

  Future<Either<Failure, void>> call(String userId, String category, double amount, String dueDate) async {
    return await repository.updateExpense(userId, category, amount, dueDate);
  }
} 