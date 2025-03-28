import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  final double amount;
  final String dueDate;
  final DateTime? updatedAt;

  const ExpenseModel({
    required this.amount,
    required this.dueDate,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      amount: (json['amount'] is int) 
          ? (json['amount'] as int).toDouble() 
          : json['amount'] as double,
      dueDate: json['dueDate'],    
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dueDate': dueDate,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [dueDate, amount, updatedAt];
} 