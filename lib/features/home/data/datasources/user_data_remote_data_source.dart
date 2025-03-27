import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import '../models/user_data_model.dart';

abstract class UserDataRemoteDataSource {
  Future<Either<Failure, void>> saveUserSalary(String userId, double salary);
  Future<Either<Failure, double>> loadUserSalary(String userId);
  Future<Either<Failure, void>> saveExpense(String userId, String category, double amount);
  Future<Either<Failure, UserDataModel>> loadUserData(String userId);
}

class UserDataRemoteDataSourceImpl implements UserDataRemoteDataSource {
  final FirebaseFirestore firestore;

  UserDataRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, void>> saveUserSalary(String userId, double salary) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'salary': salary,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, double>> loadUserSalary(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return Left(ServerFailure());
      }
      final data = doc.data();
      if (data == null || !data.containsKey('salary')) {
        return Left(ServerFailure());
      }
      return Right(data['salary'] is int ? (data['salary'] as int).toDouble() : data['salary'] as double);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveExpense(String userId, String category, double amount) async {
    try {
      // Update the specific expense category in the user document
      final Map<String, dynamic> updateData = {
        category: amount,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Log what we're saving for debugging
      print('Saving expense: $category = $amount for user $userId');
      
      await firestore.collection('users').doc(userId).set(
        updateData, 
        SetOptions(merge: true)
      );
      
      return const Right(null);
    } catch (e) {
      print('Error saving expense: $e');
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, UserDataModel>> loadUserData(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return Left(ServerFailure());
      }
      final data = doc.data();
      if (data == null) {
        return Left(ServerFailure());
      }
      
      // Log the data we received for debugging
      print('Loaded user data: $data');
      
      return Right(UserDataModel.fromJson(data, userId));
    } catch (e) {
      print('Error loading user data: $e');
      return Left(ServerFailure());
    }
  }
} 