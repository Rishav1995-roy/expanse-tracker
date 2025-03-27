import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw AuthException('Sign in failed');
      }
      
      try {
        return UserModel.fromFirebase(userCredential.user);
      } catch (e) {
        // If user model conversion fails, create a basic user model
        return UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw InvalidCredentialsException(e.message ?? 'Invalid email or password');
      } else {
        throw AuthException(e.message ?? 'Authentication failed');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw AuthException('Sign up failed');
      }
      
      try {
        return UserModel.fromFirebase(userCredential.user);
      } catch (e) {
        // If user model conversion fails, create a basic user model
        return UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else {
        throw AuthException(e.message ?? 'Authentication failed');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        try {
          return UserModel.fromFirebase(user);
        } catch (e) {
          // If user model conversion fails, create a basic user model
          return UserModel(
            id: user.uid,
            email: user.email ?? '',
          );
        }
      }
      return null;
    } catch (e) {
      throw ServerException();
    }
  }
} 