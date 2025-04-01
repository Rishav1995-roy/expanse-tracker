import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../repositories/user_data_repository.dart';

class DeleteExpense {
  final UserDataRepository repository;

  DeleteExpense(this.repository);

  Future<Either<Failure, void>> call(String userId, String category) async {
    return await repository.deleteExpense(userId, category);
  }
} 