import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signInWithEmailAndPassword(
          email,
          password,
        );
        return Right(user);
      } on InvalidCredentialsException catch (e) {
        return Left(InvalidCredentialsFailure(e.message));
      } on ServerException {
        return const Left(ServerFailure());
      } on AuthException catch (e) {
        return Left(InvalidCredentialsFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUpWithEmailAndPassword(
          email,
          password,
        );
        return Right(user);
      } on EmailAlreadyInUseException {
        return const Left(EmailAlreadyInUseFailure());
      } on WeakPasswordException {
        return const Left(WeakPasswordFailure());
      } on ServerException {
        return const Left(ServerFailure());
      } on AuthException catch (e) {
        return Left(InvalidCredentialsFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

} 