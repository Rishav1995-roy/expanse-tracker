import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'expense_model.dart';

class UserDataModel extends Equatable {
  final String userId;
  final double? salary;
  final List<ExpenseModel> expenses;
  final DateTime? updatedAt;

  const UserDataModel({
    required this.userId,
    this.salary,
    this.expenses = const [],
    this.updatedAt,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json, String userId) {
    // Extract expenses from the JSON
    final List<ExpenseModel> expensesList = [];
    final Map<String, dynamic> userData = Map<String, dynamic>.from(json);
    
    // Known fields that aren't expenses
    final nonExpenseFields = ['salary', 'updatedAt', 'userId', 'email', 'displayName'];
    
    // Remove known non-expense fields
    for (var field in nonExpenseFields) {
      userData.remove(field);
    }
    
    // Process remaining fields as potential expenses
    userData.forEach((key, value) {
      if (value is num) {
        print('Processing expense: $key = $value');
        expensesList.add(
          ExpenseModel(
            category: key,
            amount: value is int ? value.toDouble() : value as double,
            updatedAt: json['updatedAt'] != null 
                ? (json['updatedAt'] is Timestamp 
                    ? (json['updatedAt'] as Timestamp).toDate()
                    : DateTime.now())
                : null,
          ),
        );
      }
    });

    // Sort expenses by amount (highest first)
    expensesList.sort((a, b) => b.amount.compareTo(a.amount));

    return UserDataModel(
      userId: userId,
      salary: json['salary'] != null 
          ? (json['salary'] is int)
              ? (json['salary'] as int).toDouble()
              : json['salary'] as double
          : null,
      expenses: expensesList,
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.now())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'updatedAt': FieldValue.serverTimestamp(),
    };
    
    if (salary != null) {
      data['salary'] = salary;
    }
    
    // Add expenses to the main document
    for (var expense in expenses) {
      data[expense.category] = expense.amount;
    }
    
    return data;
  }

  @override
  List<Object?> get props => [userId, salary, expenses, updatedAt];
} 