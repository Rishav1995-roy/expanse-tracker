import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoURL,
  });

  factory UserModel.fromFirebase(firebase_auth.User? user) {
    if (user == null) {
      throw Exception('User is null');
    }
    
    try {
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
      );
    } catch (e) {
      // If there's an error with user details, create a basic user model
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }
} 