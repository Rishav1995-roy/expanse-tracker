import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expanse_tracker_app/core/error/failures.dart';
import 'package:flutter/material.dart';
import '../models/user_data_model.dart';

abstract class UserDataRemoteDataSource {
  Future<Either<Failure, void>> saveUserSalary(
    String userId,
    double salary,
    String fcmToken,
  );
  Future<Either<Failure, void>> updateUserSalary(
    String userId,
    double salary,
  );
  Future<Either<Failure, double>> loadUserSalary(String userId);
  Future<Either<Failure, void>> saveUserToken(String userId, String fcmToken);
  Future<Either<Failure, void>> saveExpense(
    String userId,
    String category,
    double amount,
    String dueDate,
  );
  Future<Either<Failure, void>> updateExpense(
    String userId,
    String category,
    double amount,
    String dueDate,
  );
  Future<Either<Failure, UserDataModel>> loadUserData(String userId);
  Future<Either<Failure, void>> deleteExpanse(
    String userId,
    String category,
  );
}

class UserDataRemoteDataSourceImpl implements UserDataRemoteDataSource {
  final FirebaseFirestore firestore;

  UserDataRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, void>> saveUserSalary(
      String userId, double salary, String fcmToken) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'salary': salary,
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, double>> loadUserSalary(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return const Left(ServerFailure());
      }
      final data = doc.data();
      if (data == null || !data.containsKey('salary')) {
        return const Left(ServerFailure());
      }
      return Right(data['salary'] is int
          ? (data['salary'] as int).toDouble()
          : data['salary'] as double);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveExpense(
    String userId,
    String category,
    double amount,
    String dueDate,
  ) async {
    try {
      // Update the specific expense category in the user document
      final Map<String, dynamic> updateData = {
        category: {
          'amount': amount,
          'dueDate': dueDate,
          'updatedAt': FieldValue.serverTimestamp(),
        }
      };

      // Log what we're saving for debugging
      debugPrint('Saving expense: $category = $amount for user $userId');

      await firestore
          .collection('users')
          .doc(userId)
          .set(updateData, SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserDataModel>> loadUserData(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return const Left(ServerFailure());
      }
      final data = doc.data();
      if (data == null) {
        return const Left(ServerFailure());
      }

      return Right(UserDataModel.fromJson(data, userId));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveUserToken(
      String userId, String fcmToken) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUserSalary(
    String userId,
    double salary,
  ) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'salary': salary,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpanse(
      String userId, String category) async {
    try {
      await firestore.collection('users').doc(userId) .update({category: FieldValue.delete()});
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(
    String userId,
    String category,
    double amount,
    String dueDate,
  ) async {
    try {
      // Update the specific expense category in the user document
      final Map<String, dynamic> updateData = {
        category: {
          'amount': amount,
          'dueDate': dueDate,
          'updatedAt': FieldValue.serverTimestamp(),
        }
      };

      // Log what we're saving for debugging
      debugPrint('Saving expense: $category = $amount for user $userId');

      await firestore
          .collection('users')
          .doc(userId)
          .update(updateData);

      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
