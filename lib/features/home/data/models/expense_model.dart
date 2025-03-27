import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  final String category;
  final double amount;
  final DateTime? updatedAt;

  const ExpenseModel({
    required this.category,
    required this.amount,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json, String category) {
    return ExpenseModel(
      category: category,
      amount: (json['amount'] is int) 
          ? (json['amount'] as int).toDouble() 
          : json['amount'] as double,
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [category, amount, updatedAt];
} 