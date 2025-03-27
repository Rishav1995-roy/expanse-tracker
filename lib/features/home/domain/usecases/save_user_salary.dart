import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../repositories/user_data_repository.dart';

class SaveUserSalary {
  final UserDataRepository repository;

  SaveUserSalary(this.repository);

  Future<Either<Failure, void>> call(String userId, double salary) async {
    return await repository.saveUserSalary(userId, salary);
  }
} 