import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import 'package:expanse_tracker_app/features/home/domain/repositories/user_data_repository.dart';

class SaveFcmToken {
  final UserDataRepository repository;

  SaveFcmToken(this.repository);

  Future<Either<Failure, void>> call(String userId, String fcmToken) async {
    return await repository.saveUserToken(userId, fcmToken);
  }
}