import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../../data/models/user_data_model.dart';
import '../repositories/user_data_repository.dart';

class LoadUserData {
  final UserDataRepository repository;

  LoadUserData(this.repository);

  Future<Either<Failure, UserDataModel>> call(String userId) async {
    return await repository.loadUserData(userId);
  }
} 