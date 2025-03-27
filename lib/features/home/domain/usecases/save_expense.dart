import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../repositories/user_data_repository.dart';

class SaveExpense {
  final UserDataRepository repository;

  SaveExpense(this.repository);

  Future<Either<Failure, void>> call(String userId, String category, double amount) async {
    return await repository.saveExpense(userId, category, amount);
  }
} 