import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../repositories/user_data_repository.dart';

class LoadUserSalary {
  final UserDataRepository repository;

  LoadUserSalary(this.repository);

  Future<Either<Failure, double?>> call(String userId) async {
    return await repository.loadUserSalary(userId);
  }
} 