import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
  });
  
  @override
  List<Object?> get props => [id, email, displayName, photoURL];
} 